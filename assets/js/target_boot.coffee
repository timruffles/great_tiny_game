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