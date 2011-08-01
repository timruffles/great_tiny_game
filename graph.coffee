
RainbowSpark = (@cvs) ->
  if @ctx = @cvs.getContext('2d')
    @ctx.fillStyle = "#494948"
    @ctx.fillRect(0,0,300,150)
    @ctx.globalCompositeOperation = "destination-out" # remove line
    @ctx.beginPath()
    @ctx.moveTo 0,150
    @ctx.lineWidth = 1.3
    @ctx.quadraticCurveTo(25,60,120,40)
    @ctx.moveTo 120,40
    @ctx.quadraticCurveTo(150,80,300,80)
    @ctx.stroke()
    
    @ctx.globalCompositeOperation = "destination-over" # draw background
    grad = ctx.createLinearGradient(0,0,0,150)
    grad.addColorStop(0, 'red')
    grad.addColorStop(1 / 3, 'green')
    grad.addColorStop(2 / 3, 'aqua')
    grad.addColorStop(1, 'blue')
    @ctx.fillStyle=grad
    @ctx.fillRect(0,0,300,150)
    
document.addEventListener "DOMContentLoaded", ->
  RainbowSpark document.getElementById("graph")