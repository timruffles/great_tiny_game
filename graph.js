(function() {
  var RainbowSpark, data;
  data = [];
  Number.prototype.times = function(fn) {
    var times, _results;
    times = this;
    _results = [];
    while (times--) {
      _results.push(fn());
    }
    return _results;
  };
  (10).times(function() {
    return data.push(Math.round(Math.random() * 100));
  });
  RainbowSpark = function(cvs, data) {
    var first, grad, height, lastX, lastY, perItem, width, _ref;
    this.cvs = cvs;
    width = 300;
    height = 150;
    if (this.ctx = this.cvs.getContext('2d')) {
      this.ctx.fillStyle = "#494948";
      this.ctx.fillRect(0, 0, width, height);
      this.ctx.globalCompositeOperation = "destination-out";
      perItem = width / (data.length - 1);
      this.ctx.lineWidth = 1.8;
      lastY = null;
      first = data.shift() / 100;
      _ref = [0, first * height], lastX = _ref[0], lastY = _ref[1];
      data.forEach(function(item, offset) {
        var x, y, _ref2;
        x = perItem * (offset + 1);
        y = (item / 100) * height;
        this.ctx.beginPath();
        this.ctx.moveTo(lastX, lastY);
        this.ctx.lineTo(x, y);
        _ref2 = [x, y], lastX = _ref2[0], lastY = _ref2[1];
        this.ctx.stroke();
        return console.log(x, y);
      });
      this.ctx.globalCompositeOperation = "destination-over";
      grad = ctx.createLinearGradient(0, 0, 0, height);
      grad.addColorStop(0, '#6CFF3F');
      grad.addColorStop(1 / 2, 'aqua');
      grad.addColorStop(1, '#40ACFF');
      this.ctx.fillStyle = grad;
      return this.ctx.fillRect(0, 0, width, height);
    }
  };
  document.addEventListener("DOMContentLoaded", function() {
    return RainbowSpark(document.getElementById("graph"), data);
  });
}).call(this);
