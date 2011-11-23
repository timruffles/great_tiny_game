var game;
game = function() {
  var acos, aim, armEl, asin, atan2, canvas, cos, ctx, duelist, duelistEl, fired, lastAngle, lastEvt, originalRotation, sin, tan, turn, turnEl, turned;
  armEl = $("#arm");
  duelistEl = $("#duelist");
  canvas = $("<canvas width='800' height='800' />");
  ctx = canvas[0].getContext("2d");
  aim = 1 / 2 * Math.PI;
  duelist = {
    x: 300,
    y: 200,
    armLength: 30,
    height: 100,
    moving: true,
    armAngle: 0,
    armOffset: {
      y: 150,
      x: 150
    },
    fired: false
  };
  turnEl = null;
  turned = function() {
    var fireEl;
    $("<div id='turned'>Fire!</div>").appendTo(document.body);
    duelistEl.addClass("turned");
    document.addEventListener("mousedown", function(evt) {
      return fired();
    });
    turnEl.remove();
    return fireEl = $("<div id='turn'>\n  <p class=\"command\">\n    Fire!\n  </p>\n  <ul class=\"help\">\n    <li>Click or touch to fire</li>\n  </ul>\n</div>").appendTo(document.body);
  };
  fired = function() {
    var angle;
    if (duelist.fired) {
      return;
    }
    angle = duelist.armAngle;
    duelist.fired = true;
    $("<div id='fired'>Await the outcome...</div>").appendTo(document.body);
    return duelistEl.remove();
  };
  turn = function() {
    turnEl = $("<div id='turn'>\n  <p class=\"command\">\n    Turn\n  </p>\n  <ul class=\"help\">\n    <li>Press any key to turn</li>\n  </ul>\n</div>").appendTo(document.body);
    return document.addEventListener("keydown", function(evt) {
      if (!duelist.moving) {
        return;
      }
      duelist.moving = false;
      return turned();
    });
  };
  tan = Math.tan, sin = Math.sin, cos = Math.cos, asin = Math.asin, acos = Math.acos, atan2 = Math.atan2;
  setInterval((function() {
    if (duelist.moving) {
      duelist.x += 5;
    }
    return duelistEl.css({
      left: duelist.x
    });
  }), 100);
  setTimeout(turn, 1000 + (Math.random() * 3000));
  console.log(duelist.x + duelist.armOffset.x);
  console.log(duelist.y + duelist.armOffset.y);
  lastEvt = null;
  lastAngle = null;
  originalRotation = Math.PI * 0.5;
  return document.body.addEventListener("mousemove", function(evt) {
    var normalX, normalY, _ref;
    _ref = [evt.clientX - (duelist.x + duelist.armOffset.x + 20), evt.clientY - (duelist.y + duelist.armOffset.y)], normalX = _ref[0], normalY = _ref[1];
    duelist.armAngle = atan2(normalY, normalX) - originalRotation;
    return armEl.css({
      "-webkit-transform": "rotate(" + duelist.armAngle + "rad)"
    });
  });
};
document.addEventListener("DOMContentLoaded", game);