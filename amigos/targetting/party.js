var Item, ItemChooser, Member, MemberView, idEvent;
Number.prototype.times = function(fn) {
  var time, _results;
  time = 1;
  _results = [];
  while (!(time++ >= this)) {
    _results.push(fn(time));
  }
  return _results;
};
Member = Model.extend({
  initialize: function(attrs, _arg) {
    this.items = _arg.items;
  },
  select: function(id) {
    return this.set({
      active: this.items.get(id)
    });
  },
  toString: function() {
    return "Member";
  }
});
Item = Model.extend({
  toString: function() {
    return "Item";
  }
});
MemberView = View.extend({
  className: "member",
  template: "<div class=\"portrait\">\n  <img src=\"img/{{name}}.png\" />\n  {{name}}\n</div>\n{{#item}}\n  <span class=\"item\" style=\"color:{{color}}\">\n    {{name}}\n  </span>\n{{/item}}\n<span class=\"choose\">\n    Edit\n</span>",
  events: {
    ".choose click": "change",
    ".portrait click": "trigger"
  },
  initialize: function(_arg) {
    this.itemChooser = _arg.itemChooser;
    _.bindAll(this, "render", "change", "trigger");
    this.model.bind("change", this.render);
    return this.render();
  },
  render: function() {
    var _ref;
    return this.el.innerHTML = toHtml(this.template, _.extend(this.model.toJSON(), {
      item: (_ref = this.model.get("active")) != null ? _ref.toJSON() : void 0
    }));
  },
  change: function() {
    p("change");
    this.itemChooser.model = this.model;
    this.itemChooser.render();
    return this.itemChooser.toggle();
  },
  trigger: function() {
    return this.model.get("active").trigger();
  }
});
idEvent = function(fn) {
  return function(evt) {
    var id;
    id = Number(evt.target.getAttribute("data-id"));
    return fn.call(this, id, evt.target);
  };
};
ItemChooser = View.extend({
  className: "chooser",
  template: "{{#items}}\n  <li data-id=\"{{id}}\" class=\"item\" style=\"border: 2px solid {{color}}\">{{name}}</option>\n{{/items}}",
  initialize: function() {
    _.bindAll(this, "select");
    return this.toggle();
  },
  render: function() {
    return this.el.innerHTML = toHtml(this.template, {
      items: this.model.items.toJSON()
    });
  },
  events: {
    ".item click": "select"
  },
  select: idEvent(function(id) {
    this.model.select(id);
    return this.toggle();
  }),
  toggle: function() {
    return this.el.classList.toggle("hidden");
  }
});