members = [
    {
        name: "Garcia",
        portrait: "garcia",
        items: new (Collection.extend model: Item)([
          {id: 1, name: "Pistol", color: "red"}
          {id: 2, name: "Sword Stick", color: "blue"}
        ])
    }
    {
        name: "Artez",
        portrait: "artez",
        items: new (Collection.extend model: Item)([
          {id: 1, name: "Shield-Latern", color: "red"}
          {id: 2, name: "Blunderbuss", color: "blue"}
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
    
onDom ->
  doc.body.appendChild views.itemChooser.el
  mems = doc.byId "members"
  for view in views.members
    mems.appendChild view.el