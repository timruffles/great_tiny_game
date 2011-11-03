doc = document
doc.byId = doc.getElementById

Number::times = (fn) ->
  iter = 0
  while iter++ < this
    fn(iter)

PubSub = ->
  subs = {}
  @sub = (evt,fn) =>
    subs[evt] ||= []
    subs[evt].push fn 
    [evt,fn]
  @unsub = ([evt,fn]) =>
    index = subs[evt].indexOf(fn)
    subs[evt].splice(index,1)
  @pub = (evt,args) =>
    subs[evt].each (fn) -> fn.apply(this,args)
  this

Ticker = (@pubSub) ->
  @control = stopped: false
  @tick = =>
    now = new Date
    lastTick ||= now
    delta = Math.min(now - lastTick,1000)
    @pubSub.pub "tick", delta
    lastTick = now
    unless @control.stopped
      setTimeout @tick, 1000 / 30
  this

Model = {}
View = {}

isDown = (->
  keys = {}
  keyWatcher = ->
    doc.body.on "keydown", (evt) ->
      keys[evt.key] = true
    doc.body.on "keyup", (evt) ->
      keys[evt.key] = false
  keyWatcher()
  
  (key) ->
    !!(keys[key])
)()

# game code

Duelist = (model) ->
  sub "pace", ->
    if keyIsDown walkingDirection
      model.walked()
    else
      model.stopped()
  sub "turn", ->
    display "Turn!"
    doc.body.on
  sub "walked", -> animate "walk"
  sub "stopped", -> animate "stopped"
  
  $(document.body).click (evt) ->
    m = evt.screenY / evt.screenX
    

Announcer = (model) ->

Duelist = ->
  @x = 0
  @pace = =>
    @x += 1

  

GameView = ->


Game = ->

  pubSub = new PubSub

  ticker = new Ticker(pubSub)

  @start = =>
    trigger "started"




# init code
$ ->
  game = new Game
  view = new GameView game


