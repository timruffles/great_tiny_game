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