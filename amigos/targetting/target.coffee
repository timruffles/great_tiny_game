doc = document
$ = doc.querySelectorAll
doc.byId = document.getElementById
Element::on = Element::addEventListener
Element::ignore = Element::removeEventListener
Element::$ = Element::querySelectorAll

String::toFloat = -> if this + "" == "" then 0 else parseFloat this
String::toInt = -> if this + "" == "" then 0 else parseInt this

onDom = (fn) ->
  window.addEventListener "load", fn

Model = Backbone.Model
View = (opts)->
  @construct(opts)
  @initialize(opts)
  p "called #{@el}"
View:: =
  construct: ({@collection,@model,@el}) ->
    @make() unless @el
  initialize: (opts) ->
  make: ->
    @el = doc.createElement "div"
    @el.classList.add @className if @className
  render: ->
    @el.innerHTML = Mustache.to_html(this.template,this.transform())
  transform: ->
    @model.toJSON()
View.extend = Backbone.Collection.extend
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
    
DoomButton = View.extend
  initialize: ({@target,@enemiesView}) ->
    _.bindAll this, "fire"
    @el.on "click", @fire
  fire: (evt) ->
    targetRect = @target.getBoundingClientRect()
    # quick hack - need to neatent this up and properly 
    # relate view to model
    @collection.filter (enemy) =>
      rect = @enemiesView.getView(enemy).el.getBoundingClientRect()
      if (targetRect.left < rect.left < targetRect.right) or
         (targetRect.left < rect.right < targetRect.right)
        enemy.hit()
    evt.preventDefault()
  
onDom ->

  update = (diff, time) ->
    spawn()
    
  modelEvents = _.extend {}, Backbone.Events
  viewEvents = _.extend {}, Backbone.Events
  
  View::pub = viewEvents
  Model::pub = Collection::pub = modelEvents
  
  # model
  enemies = new Enemy.Collection()
  
  level = new Level {lives: 10},
    enemies: enemies
    
  level.bind "lost", ->
    alert("You lose")
    window.location.reload()
    
  #view
  enemiesView = new EnemiesView
    collection: enemies
    el: doc.byId "threats"
    
  lives = new Lives
    model: level
    collection: enemies
    
  lives.render()

  doc.body.appendChild lives.el
  
  target = doc.byId "target"
  track = doc.byId "threats"
    
  Target(target,track)
  
  button = new DoomButton
    target: target
    enemiesView: enemiesView
    collection: enemies
    el: doc.byId "doom"
    
  lastTime = new Date - 0
  gameTime = 0
  maxDiff = 1000
  ticker = (time) ->
    diff = (time - lastTime)
    gameTime += Math.min diff, maxDiff
    diff /= 1000
    modelEvents.trigger "tick", diff, gameTime
    viewEvents.trigger "tick", diff, gameTime
    lastTime = time
   animation = animate ticker


  