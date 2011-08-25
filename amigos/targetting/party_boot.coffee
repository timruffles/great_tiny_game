names = ["Tom","Dick","Harry","Gonzales"]
items = ["Sword-stick","Pistol","Stiletto","Bill of exchange"]

views = 
  members: []
  itemChooser: null
models = 
  members: new (Collection.extend model: Member)
  
views.itemChooser = new ItemChooser {}
  
4.times ->
  models.members.add member = 
    new Member
      name: names.sample()
    , {
      items: new (Collection.extend model: Item)([{id: 1, name: items.sample()},{id: 2, name: items.sample()}])
    }
  
  views.members.push new MemberView
    model: member
    itemChooser: views.itemChooser
    
onDom ->
  doc.body.appendChild views.itemChooser.el
  mems = doc.byId "members"
  for view in views.members
    mems.appendChild view.el