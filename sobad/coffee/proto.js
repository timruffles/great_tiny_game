var game;
game = function() {
  var acos, aim, asin, atan, cos, ctx, cvs, duelist, lastAngle, lastEvt, sin, tan;
  cvs = document.getElementById("canvas");
  ctx = cvs.getContext("2d");
  aim = 1 / 2 * Math.PI;
  duelist = {
    x: 300,
    y: 300,
    armLength: 30,
    height: 100
  };
  tan = Math.tan, sin = Math.sin, cos = Math.cos, asin = Math.asin, acos = Math.acos, atan = Math.atan;
  lastEvt = null;
  lastAngle = null;
  return cvs.addEventListener("mousemove", function(evt) {
    var currentAngle, endX, endY, startX, startY, unitX, unitY, _ref, _ref2, _ref3;
    cvs.width = cvs.width;
    currentAngle = atan((evt.offsetY - duelist.y) / (evt.offsetX - duelist.x));
    _ref = [cos(currentAngle), sin(currentAngle)], unitX = _ref[0], unitY = _ref[1];
    console.log(currentAngle);
    if (((Math.PI * 0.5 < currentAngle && currentAngle < Math.PI * 1)) || ((Math.PI * 1 / 2 < currentAngle && currentAngle < Math.PI * 1))) {
      console.log("hi");
      unitX = -unitX;
      unitY = -unitY;
    }
    _ref2 = [duelist.x, duelist.y], startX = _ref2[0], startY = _ref2[1];
    _ref3 = [duelist.x + unitX * 100, duelist.y + unitY * 100], endX = _ref3[0], endY = _ref3[1];
    ctx.strokStyle = "red";
    ctx.moveTo(startX, startY);
    ctx.lineTo(endX, endY);
    return ctx.stroke();
  });
};
document.addEventListener("DOMContentLoaded", game);