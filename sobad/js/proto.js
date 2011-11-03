var game;
game = function() {
  var acos, aim, armEl, asin, atan2, cos, duelist, duelistEl, fired, lastAngle, lastEvt, sin, tan, turn, turned;
  armEl = $("#arm");
  duelistEl = $("#duelist");
  aim = 1 / 2 * Math.PI;
  duelist = {
    x: 300,
    y: 200,
    armLength: 30,
    height: 100,
    moving: true,
    armAngle: 0,
    armOffset: {
      y: 180,
      x: 180
    }
  };
  turned = function() {
    return $("<div id='turned'>Fire!</div>").appendTo(document.body);
  };
  fired = function() {
    return $("<div id='fired'>Await the outcome...</div>").appendTo(document.body);
  };
  turn = function() {
    $("<div id='turn'>Turn</div>").appendTo(document.body);
    document.body.addEventListener("keydown", function(evt) {
      if (evt.keyCode === 65) {
        duelist.moving = false;
      }
      return turned();
    });
    return document.body.addEventListener("mousedown", function(evt) {
      return fired();
    });
  };
  tan = Math.tan, sin = Math.sin, cos = Math.cos, asin = Math.asin, acos = Math.acos, atan2 = Math.atan2;
  setInterval((function() {
    if (duelist.moving) {
      duelist.x += 5;
    }
    duelistEl.css({
      left: duelist.x
    });
    return armEl.css({
      left: parseInt(armEl.css("left")) + 5
    });
  }), 100);
  setTimeout(turn, 1000 + (Math.random() * 3000));
  lastEvt = null;
  lastAngle = null;
  return document.body.addEventListener("mousemove", function(evt) {
    var normalX, normalY, _ref;
    _ref = [evt.offsetX - (duelist.x + duelist.armOffset.x), evt.offsetY - (duelist.y + duelist.armOffset.y)], normalX = _ref[0], normalY = _ref[1];
    duelist.armAngle = atan2(normalY, normalX);
    return armEl.css({
      "-webkit-transform": "rotate(" + duelist.armAngle + "rad)"
    });
  });
};
document.addEventListener("DOMContentLoaded", game);