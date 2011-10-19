onDom ->

  modelEvents = _.extend {}, Backbone.Events
  viewEvents = _.extend {}, Backbone.Events
  
  View::pub = viewEvents
  Model::pub = Collection::pub = modelEvents
  
  # model
  enemies = new Enemy.Collection()
  
  level = new Level {lives: 10},
    enemies: enemies
    
  level.bind "lost", ->
    alert("The day is lost!")
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
  
  lastTime = new Date - 0
  gameTime = 0
  maxDiff = 1000
  
  game = 
    paused: false
  ticker = (time) ->
    unless game.paused
      diff = (time - lastTime)
      gameTime += Math.min diff, maxDiff
      diff /= 1000
      modelEvents.trigger "tick", diff, gameTime
      viewEvents.trigger "tick", diff, gameTime
    lastTime = time
    
  animation = animate ticker
  
  viewEvents.bind "rpg:enter", -> game.paused = true
  viewEvents.bind "rpg:exit", -> game.paused = false
   
  members = [
    {
        name: "Garcia",
        portrait: "garcia",
        items: new (Collection.extend model: Item)([
          {id: 1, name: "Tongue of the Demagogue", type: "political"}
          {id: 2, name: "Chastity Belt", type: "moral"}
        ])
    }
    {
        name: "Artez",
        portrait: "artez",
        items: new (Collection.extend model: Item)([
          {id: 1, name: "Sword-stick", type: "physical"}
          {id: 2, name: "Louis XV's Letter of Marque", type: "financial"}
        ])
    }
  ]

  views = 
    members: []
    itemChooser: null
  models = 
    members: new (Collection.extend model: Member)
    
  views.itemChooser = new ItemChooser {}

  members.forEach (memberData) ->
    items = memberData.items
    delete memberData.items
    models.members.add member = new Member(memberData,items: items)

    views.members.push new MemberView
      model: member
      itemChooser: views.itemChooser

  doc.body.appendChild views.itemChooser.el
  mems = doc.byId "members"
  for view in views.members
    mems.appendChild view.el

  resolveActivation = (item) ->
   targetRect = target.getBoundingClientRect()
   # quick hack - need to neatent this up and properly 
   # relate view to model
   enemies.filter (enemy) =>
     rect = enemiesView.getView(enemy).el.getBoundingClientRect()
     if (targetRect.left < rect.left < targetRect.right) or
        (targetRect.left < rect.right < targetRect.right)
       enemy.hit(item)

  views.members.forEach (member) ->
    member.bind "activate", (item) -> resolveActivation(item)

   