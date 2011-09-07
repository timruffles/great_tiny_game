var members, models, views;
members = [
  {
    name: "Garcia",
    portrait: "garcia",
    items: new (Collection.extend({
      model: Item
    }))([
      {
        id: 1,
        name: "Pistol",
        color: "red"
      }, {
        id: 2,
        name: "Sword Stick",
        color: "blue"
      }
    ])
  }, {
    name: "Artez",
    portrait: "artez",
    items: new (Collection.extend({
      model: Item
    }))([
      {
        id: 1,
        name: "Shield-Latern",
        color: "red"
      }, {
        id: 2,
        name: "Blunderbuss",
        color: "blue"
      }
    ])
  }
];
views = {
  members: [],
  itemChooser: null
};
models = {
  members: new (Collection.extend({
    model: Member
  }))
};
views.itemChooser = new ItemChooser({});
members.forEach(function(memberData) {
  var items, member;
  items = memberData.items;
  delete memberData.items;
  models.members.add(member = new Member(memberData, {
    items: items
  }));
  return views.members.push(new MemberView({
    model: member,
    itemChooser: views.itemChooser
  }));
});
onDom(function() {
  var mems, view, _i, _len, _ref, _results;
  doc.body.appendChild(views.itemChooser.el);
  mems = doc.byId("members");
  _ref = views.members;
  _results = [];
  for (_i = 0, _len = _ref.length; _i < _len; _i++) {
    view = _ref[_i];
    _results.push(mems.appendChild(view.el));
  }
  return _results;
});