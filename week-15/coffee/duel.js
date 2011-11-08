var Announcer, Duelist, Game, GameView, Model, PubSub, Ticker, View, doc, isDown;
var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
doc = document;
doc.byId = doc.getElementById;
Number.prototype.times = function(fn) {
  var iter, _results;
  iter = 0;
  _results = [];
  while (iter++ < this) {
    _results.push(fn(iter));
  }
  return _results;
};
PubSub = function() {
  var subs;
  subs = {};
  this.sub = __bind(function(evt, fn) {
    subs[evt] || (subs[evt] = []);
    subs[evt].push(fn);
    return [evt, fn];
  }, this);
  this.unsub = __bind(function(_arg) {
    var evt, fn, index;
    evt = _arg[0], fn = _arg[1];
    index = subs[evt].indexOf(fn);
    return subs[evt].splice(index, 1);
  }, this);
  this.pub = __bind(function(evt, args) {
    return subs[evt].each(function(fn) {
      return fn.apply(this, args);
    });
  }, this);
  return this;
};
Ticker = function(pubSub) {
  this.pubSub = pubSub;
  this.control = {
    stopped: false
  };
  this.tick = __bind(function() {
    var delta, lastTick, now;
    now = new Date;
    lastTick || (lastTick = now);
    delta = Math.min(now - lastTick, 1000);
    this.pubSub.pub("tick", delta);
    lastTick = now;
    if (!this.control.stopped) {
      return setTimeout(this.tick, 1000 / 30);
    }
  }, this);
  return this;
};
Model = {};
View = {};
isDown = (function() {
  var keyWatcher, keys;
  keys = {};
  keyWatcher = function() {
    doc.body.on("keydown", function(evt) {
      return keys[evt.key] = true;
    });
    return doc.body.on("keyup", function(evt) {
      return keys[evt.key] = false;
    });
  };
  keyWatcher();
  return function(key) {
    return !!keys[key];
  };
})();
Duelist = function(model) {
  sub("pace", function() {
    if (keyIsDown(walkingDirection)) {
      return model.walked();
    } else {
      return model.stopped();
    }
  });
  sub("turn", function() {
    display("Turn!");
    return doc.body.on;
  });
  sub("walked", function() {
    return animate("walk");
  });
  sub("stopped", function() {
    return animate("stopped");
  });
  return $(document.body).click(function(evt) {
    var m;
    return m = evt.screenY / evt.screenX;
  });
};
Announcer = function(model) {};
Duelist = function() {
  this.x = 0;
  return this.pace = __bind(function() {
    return this.x += 1;
  }, this);
};
GameView = function() {};
Game = function() {
  var pubSub, ticker;
  pubSub = new PubSub;
  ticker = new Ticker(pubSub);
  return this.start = __bind(function() {
    return trigger("started");
  }, this);
};
$(function() {
  var game, view;
  game = new Game;
  return view = new GameView(game);
});