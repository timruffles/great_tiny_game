(function() {
  var RainbowSpark;
  RainbowSpark = function(cvs) {
    var grad;
    this.cvs = cvs;
    if (this.ctx = this.cvs.getContext('2d')) {
      this.ctx.fillStyle = "#494948";
      this.ctx.fillRect(0, 0, 300, 150);
      this.ctx.globalCompositeOperation = "destination-out";
      this.ctx.beginPath();
      this.ctx.moveTo(0, 150);
      this.ctx.lineWidth = 1.3;
      this.ctx.quadraticCurveTo(25, 60, 120, 40);
      this.ctx.moveTo(120, 40);
      this.ctx.quadraticCurveTo(150, 80, 300, 80);
      this.ctx.stroke();
      this.ctx.globalCompositeOperation = "destination-over";
      grad = ctx.createLinearGradient(0, 0, 0, 150);
      grad.addColorStop(0, 'red');
      grad.addColorStop(1 / 3, 'green');
      grad.addColorStop(2 / 3, 'aqua');
      grad.addColorStop(1, 'blue');
      this.ctx.fillStyle = grad;
      return this.ctx.fillRect(0, 0, 300, 150);
    }
  };
  document.addEventListener("DOMContentLoaded", function() {
    return RainbowSpark(document.getElementById("graph"));
  });
}).call(this);
