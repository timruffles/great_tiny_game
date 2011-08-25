var items, models, names, views;
names = ["Tom", "Dick", "Harry", "Gonzales"];
items = ["Sword-stick", "Pistol", "Stiletto", "Bill of exchange"];
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
(4).times(function() {
  var member;
  models.members.add(member = new Member({
    name: names.sample()
  }, {
    items: new (Collection.extend({
      model: Item
    }))([
      {
        id: 1,
        name: items.sample()
      }, {
        id: 2,
        name: items.sample()
      }
    ])
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