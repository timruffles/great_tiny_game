(function() {
  var $, CMDS, Collection, DoomButton, EnemiesView, Enemy, EnemyView, Level, Lives, Model, Target, View, animFrame, animate, createName, doc, onDom, p, prefixes, types;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  doc = document;
  $ = doc.querySelectorAll;
  doc.byId = document.getElementById;
  Element.prototype.on = Element.prototype.addEventListener;
  Element.prototype.ignore = Element.prototype.removeEventListener;
  Element.prototype.$ = Element.prototype.querySelectorAll;
  String.prototype.toFloat = function() {
    if (this + "" === "") {
      return 0;
    } else {
      return parseFloat(this);
    }
  };
  String.prototype.toInt = function() {
    if (this + "" === "") {
      return 0;
    } else {
      return parseInt(this);
    }
  };
  onDom = function(fn) {
    return window.addEventListener("load", fn);
  };
  Model = Backbone.Model;
  View = function(opts) {
    this.construct(opts);
    this.initialize(opts);
    return p("called " + this.el);
  };
  View.prototype = {
    construct: function(_arg) {
      this.collection = _arg.collection, this.model = _arg.model, this.el = _arg.el;
      if (!this.el) {
        return this.make();
      }
    },
    initialize: function(opts) {},
    make: function() {
      this.el = doc.createElement("div");
      if (this.className) {
        return this.el.classList.add(this.className);
      }
    },
    render: function() {
      return this.el.innerHTML = Mustache.to_html(this.template, this.transform());
    },
    transform: function() {
      return this.model.toJSON();
    }
  };
  View.extend = Backbone.Collection.extend;
  Collection = Backbone.Collection;
  p = console.log.bind(console);
  animFrame = function(fn, el) {
    return window.webkitRequestAnimationFrame(fn, el);
  };
  animate = function(fn, el) {
    var control;
    if (!fn) {
      throw new Error("No fn");
    }
    control = {
      stopped: false
    };
    animFrame(function(time) {
      fn(time);
      if (!control.stoppped) {
        return animate(fn, el);
      }
    }, el);
    return control;
  };
  Function.prototype.maxOncePerFrame = function(el) {
    var invoke, throttler;
    throttler = {};
    invoke = this;
    return function() {
      if (!throttler.throttle) {
        invoke();
        throttler.throttle = true;
        return animFrame((function() {
          return throttler.throttle = false;
        }), el);
      }
    };
  };
  CMDS = {
    start: "mousedown",
    stop: "mouseup",
    move: "mousemove"
  };
  Target = function(target, track) {
    var body, lastX, left, offset, onMove, right, targetWidth, trackBox, update, _ref, _ref2;
    targetWidth = target.offsetWidth;
    trackBox = track.getBoundingClientRect();
    _ref = [0, trackBox.width - targetWidth], left = _ref[0], right = _ref[1];
    _ref2 = [0, 0], lastX = _ref2[0], offset = _ref2[1];
    body = document.body;
    target.on(CMDS.start, function(evt) {
      lastX = event.screenX;
      return body.on(CMDS.move, onMove);
    });
    body.on(CMDS.stop, function() {
      return body.ignore(CMDS.move, onMove);
    });
    onMove = function(evt) {
      var diff, _ref3;
      diff = evt.screenX - lastX;
      lastX = evt.screenX;
      if ((0 <= (_ref3 = offset + diff) && _ref3 <= right)) {
        offset += diff;
        return update();
      }
    };
    return update = (function() {
      return target.style.left = offset;
    }).maxOncePerFrame(target);
  };
  Enemy = Model.extend({
    initialize: function() {
      return this.pub.bind("tick", __bind(function(diff) {
        this.set({
          travelled: this.get("travelled") + this.get("speed") * diff
        });
        if (this.get("travelled") > 350 && !this.attacked) {
          this.trigger("attack", this);
          return this.attacked = true;
        }
      }, this));
    },
    hit: function() {
      return this.trigger("died", this);
    }
  });
  Enemy.Collection = Collection.extend({
    initialize: function() {
      return this.bind("died", __bind(function(enemy) {
        return this.remove(enemy);
      }, this));
    },
    model: Enemy
  });
  EnemyView = View.extend({
    className: "enemy",
    initialize: function() {
      _.bindAll(this, "render", "die");
      this.needsDraw = true;
      this.el.style.right = 0;
      this.pub.bind("tick", this.render);
      return this.model.bind("died", this.die);
    },
    template: "<span class=\"name\">{{name}}</span>",
    render: function() {
      if (this.needsDraw) {
        View.prototype.render.call(this);
        this.needsDraw = false;
      }
      return this.el.style.right = this.model.get("travelled");
    },
    hit: function() {
      return this.model.hit();
    },
    die: function() {
      return this.el.parentNode.removeChild(this.el);
    }
  });
  EnemiesView = View.extend({
    initialize: function() {
      _.bindAll(this, "add", "remove");
      this.collection.bind("add", this.add);
      this.collection.bind("removed", this.remove);
      return this.viewsById = {};
    },
    add: function(enemy) {
      var enemyView;
      this.viewsById[enemy.cid] = enemyView = new EnemyView({
        model: enemy
      });
      return this.el.appendChild(enemyView.el);
    },
    remove: function(enemy) {
      return delete this.viewsById[enemy.cid];
    },
    getView: function(enemy) {
      return this.viewsById[enemy.cid || enemy];
    }
  });
  Number.prototype.sample = function() {
    return Math.round(Math.random() * this);
  };
  Array.prototype.sample = function() {
    return this[(this.length - 1).sample()];
  };
  types = ["Elephant", "Pesant", "Janissary", "Rogue", "Ruffian", "Looter", "Hippo Rider", "Ostrich Herder", "Brute"];
  prefixes = ["", "", "Armoured", "Enraged", "Grubby", "Sneaky", "Quick"];
  createName = function() {
    var amount, description, prefix, type;
    amount = (3).sample();
    type = types.sample();
    prefix = prefixes.sample();
    description = "" + prefix + " " + type;
    if (amount > 1) {
      return "Some " + description + "s";
    } else {
      return "A " + description;
    }
  };
  Level = Model.extend({
    initialize: function(attrs, _arg) {
      this.enemies = _arg.enemies;
      this.set({
        spawnNext: 0
      });
      _.bindAll(this, "tick");
      this.pub.bind("tick", this.tick);
      this.spawnTime = 6000;
      this.spawnLimit = 3;
      this.enemies.bind("attack", __bind(function() {
        return this.set({
          lives: this.get("lives") - 1
        });
      }, this));
      this.enemies.bind("died", __bind(function() {
        if (!(this.spawnTime <= 0)) {
          this.spawnTime -= 2000;
          return this.spawnLimit += 1;
        }
      }, this));
      return this.bind("change:lives", __bind(function(level, lives) {
        if (lives === 0) {
          return this.trigger("lost");
        }
      }, this));
    },
    tick: function(diff, gameTime) {
      if (gameTime > this.get("spawnNext") && this.enemies.length < this.spawnLimit) {
        this.enemies.add(new Enemy({
          speed: 50 + (50).sample(),
          travelled: 0,
          name: createName()
        }));
        return this.set({
          spawnNext: gameTime + 1000 + this.spawnTime.sample()
        });
      }
    }
  });
  Lives = View.extend({
    className: "lives",
    initialize: function() {
      _.bindAll(this, "render");
      return this.model.bind("change:lives", this.render);
    },
    render: function() {
      return this.el.innerHTML = this.model.get("lives");
    }
  });
  DoomButton = View.extend({
    initialize: function(_arg) {
      this.target = _arg.target, this.enemiesView = _arg.enemiesView;
      _.bindAll(this, "fire");
      return this.el.on("click", this.fire);
    },
    fire: function(evt) {
      var targetRect;
      targetRect = this.target.getBoundingClientRect();
      this.collection.filter(__bind(function(enemy) {
        var rect, _ref, _ref2;
        rect = this.enemiesView.getView(enemy).el.getBoundingClientRect();
        if (((targetRect.left < (_ref = rect.left) && _ref < targetRect.right)) || ((targetRect.left < (_ref2 = rect.right) && _ref2 < targetRect.right))) {
          return enemy.hit();
        }
      }, this));
      return evt.preventDefault();
    }
  });
  onDom(function() {
    var animation, button, enemies, enemiesView, gameTime, lastTime, level, lives, maxDiff, modelEvents, target, ticker, track, update, viewEvents;
    update = function(diff, time) {
      return spawn();
    };
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
      alert("You lose");
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
    button = new DoomButton({
      target: target,
      enemiesView: enemiesView,
      collection: enemies,
      el: doc.byId("doom")
    });
    lastTime = new Date - 0;
    gameTime = 0;
    maxDiff = 1000;
    ticker = function(time) {
      var diff;
      diff = time - lastTime;
      gameTime += Math.min(diff, maxDiff);
      diff /= 1000;
      modelEvents.trigger("tick", diff, gameTime);
      viewEvents.trigger("tick", diff, gameTime);
      return lastTime = time;
    };
    return animation = animate(ticker);
  });
}).call(this);
