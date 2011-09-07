doc = document
$ = doc.querySelectorAll
doc.byId = document.getElementById
Element::on = Element::addEventListener
Element::ignore = Element::removeEventListener
Element::$ = Element::querySelectorAll

toHtml = Mustache.to_html

String::toFloat = -> if this + "" == "" then 0 else parseFloat this
String::toInt = -> if this + "" == "" then 0 else parseInt this

onDom = (fn) ->
  window.addEventListener "load", fn

Model = Backbone.Model
View = (opts)->
  @construct(opts)
  @initialize(opts)
  p "called #{@el}"
  
eventSplitter = /(\S+)(?:\s+(\S+))?/

View:: =
  construct: ({@collection,@model,@el}) ->
    @make() unless @el
    @initialize(arguments[0])
    @delegate()
  initialize: (opts) ->
  make: ->
    @el = doc.createElement "div"
    @el.classList.add @className if @className
  render: ->
    @el.innerHTML = toHtml(this.template,this.transform())
  transform: ->
    @model.toJSON()
  delegate: ->
    return unless @events
    for eventSetup, handler of @events
      do (eventSetup, handler) =>
        handler = @[handler]
        if match = eventSplitter.exec eventSetup
          [whole, selector, event] = match
        unless event
          event = selector
        if selector
          @el.on event, (evt) ->
            tester = doc.createElement("div")
            tester.appendChild(evt.target.cloneNode(false))
            if tester.$(selector).length > 0
              handler(evt)
        else
          @el.on event, handler
              
            
    
View.extend = Backbone.Collection.extend
_.extend View::, Backbone.Events
Collection = Backbone.Collection

#debug
p = console.log.bind(console)

animFrame = (fn,el) -> window.webkitRequestAnimationFrame fn, el

animate = (fn,el) ->
  throw new Error "No fn" unless fn
  control = stopped: false
  animFrame (time) ->
    fn(time)
    animate fn, el unless control.stoppped
  , el
  control

Function::maxOncePerFrame = (el) ->
  throttler = {}
  invoke = this
  ->
    unless throttler.throttle
      invoke()
      throttler.throttle = true
      animFrame (-> throttler.throttle = false), el

CMDS = 
  start: "mousedown"
  stop: "mouseup"
  move: "mousemove"
  
Target = (target,track) ->
  targetWidth = target.offsetWidth
  trackBox = track.getBoundingClientRect()
  [left,right] = [0,trackBox.width - targetWidth]
  [lastX,offset] = [0,0]
  body = document.body
  target.on CMDS.start, (evt) ->
    lastX = event.screenX
    body.on CMDS.move, onMove
  body.on CMDS.stop, -> 
    body.ignore CMDS.move, onMove
  onMove = (evt) ->
    diff = evt.screenX - lastX
    lastX = evt.screenX
    if 0 <= offset + diff <= right
      offset += diff
      update()
  update = (() ->
    target.style.left = offset
  ).maxOncePerFrame(target)
  
Enemy = Model.extend
  initialize: ->
    @pub.bind "tick", (diff) =>
      @set travelled: @get("travelled") + @get("speed") * diff
      if @get("travelled") > 350 && !@attacked
        @trigger "attack", this
        @attacked = true
  hit: ->
    @trigger "died", this
Enemy.Collection = Collection.extend
  initialize: ->
    @bind "died", (enemy) =>
      @remove enemy
  model: Enemy

EnemyView = View.extend
  className: "enemy"
  initialize: ->
    _.bindAll this, "render", "die"
    @needsDraw = true
    @el.style.right = 0
    @pub.bind "tick", @render
    @model.bind "died", @die
  template: """
    <span class="name">{{name}}</span>
  """
  render: ->
    if @needsDraw
      View::render.call(this)
      @needsDraw = false
    @el.style.right = @model.get("travelled")
  hit: ->
    @model.hit()
  die: ->
    if @el.parentNode
      @el.parentNode.removeChild(@el)
EnemiesView = View.extend
  initialize: ->
    _.bindAll this, "add", "remove"
    @collection.bind "add", @add
    @collection.bind "removed", @remove
    @viewsById = {}
  add: (enemy) ->
    @viewsById[enemy.cid] = enemyView = new EnemyView
      model: enemy
    @el.appendChild enemyView.el
  remove: (enemy) ->
    delete @viewsById[enemy.cid]
  getView: (enemy) ->
    @viewsById[enemy.cid || enemy]

Number::sample = -> Math.round(Math.random() * this)
Array::sample = -> this[(this.length - 1).sample()]


types = ["Elephant","Pesant","Janissary","Rogue","Ruffian","Looter","Hippo Rider","Ostrich Herder","Brute"]
prefixes = ["","","Armoured","Enraged","Grubby","Sneaky","Quick"]
createName = ->
  amount = 3.sample()
  type = types.sample()
  prefix = prefixes.sample()
  description = "#{prefix} #{type}"
  if amount > 1
    "Some #{description}s"
  else
    "A #{description}"

Level = Model.extend
  initialize: (attrs, {@enemies}) ->
    @set spawnNext: 0
    _.bindAll this, "tick"
    @pub.bind "tick", @tick
    @spawnTime = 6000
    @spawnLimit = 3
    @enemies.bind "attack", =>
      @set lives: (@get("lives") - 1)
    @enemies.bind "died", =>
      unless @spawnTime <= 0
        @spawnTime -= 2000
        @spawnLimit += 1
    @bind "change:lives", (level,lives) => 
      if lives == 0
        @trigger "lost"
  tick: (diff,gameTime) ->
    if gameTime > @get("spawnNext") && @enemies.length < @spawnLimit
      @enemies.add new Enemy
        speed: 50 + 50.sample()
        travelled: 0
        name: createName()
      @set spawnNext: gameTime + 1000 + @spawnTime.sample()
      
Lives = View.extend
  className: "lives"
  initialize: ->
    _.bindAll this, "render"
    @model.bind "change:lives", @render
  render: ->
    @el.innerHTML = @model.get("lives")
    
  