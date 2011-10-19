var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
onDom(function() {
  var animation, enemies, enemiesView, game, gameTime, lastTime, level, lives, maxDiff, members, mems, modelEvents, models, resolveActivation, target, ticker, track, view, viewEvents, views, _i, _len, _ref;
  modelEvents = _.extend({}, Backbone.Events);
  viewEvents = _.extend({}, Backbone.Events);
  View.prototype.pub = viewEvents;
  Model.prototype.pub = Collection.prototype.pub = modelEvents;
  enemies = new Enemy.Collection();
  level = new Level({
    lives: 10
  }, {
    enemies: enemies
  });
  level.bind("lost", function() {
    alert("The day is lost!");
    return window.location.reload();
  });
  enemiesView = new EnemiesView({
    collection: enemies,
    el: doc.byId("threats")
  });
  lives = new Lives({
    model: level,
    collection: enemies
  });
  lives.render();
  doc.body.appendChild(lives.el);
  target = doc.byId("target");
  track = doc.byId("threats");
  Target(target, track);
  lastTime = new Date - 0;
  gameTime = 0;
  maxDiff = 1000;
  game = {
    paused: false
  };
  ticker = function(time) {
    var diff;
    if (!game.paused) {
      diff = time - lastTime;
      gameTime += Math.min(diff, maxDiff);
      diff /= 1000;
      modelEvents.trigger("tick", diff, gameTime);
      viewEvents.trigger("tick", diff, gameTime);
    }
    return lastTime = time;
  };
  animation = animate(ticker);
  viewEvents.bind("rpg:enter", function() {
    return game.paused = true;
  });
  viewEvents.bind("rpg:exit", function() {
    return game.paused = false;
  });
  members = [
    {
      name: "Garcia",
      portrait: "garcia",
      items: new (Collection.extend({
        model: Item
      }))([
        {
          id: 1,
          name: "Tongue of the Demagogue",
          type: "political"
        }, {
          id: 2,
          name: "Chastity Belt",
          type: "moral"
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
          name: "Sword-stick",
          type: "physical"
        }, {
          id: 2,
          name: "Louis XV's Letter of Marque",
          type: "financial"
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
  doc.body.appendChild(views.itemChooser.el);
  mems = doc.byId("members");
  _ref = views.members;
  for (_i = 0, _len = _ref.length; _i < _len; _i++) {
    view = _ref[_i];
    mems.appendChild(view.el);
  }
  resolveActivation = function(item) {
    var targetRect;
    targetRect = target.getBoundingClientRect();
    return enemies.filter(__bind(function(enemy) {
      var rect, _ref2, _ref3;
      rect = enemiesView.getView(enemy).el.getBoundingClientRect();
      if (((targetRect.left < (_ref2 = rect.left) && _ref2 < targetRect.right)) || ((targetRect.left < (_ref3 = rect.right) && _ref3 < targetRect.right))) {
        return enemy.hit(item);
      }
    }, this));
  };
  return views.members.forEach(function(member) {
    return member.bind("activate", function(item) {
      return resolveActivation(item);
    });
  });
});