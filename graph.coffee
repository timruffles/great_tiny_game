
data = []
Number::times = (fn) -> times = this; fn() while times--
10.times -> data.push Math.round(Math.random() * 100)

RainbowSpark = (@cvs,data) ->
  width = 300
  height = 150
  if @ctx = @cvs.getContext('2d')
    @ctx.fillStyle = "#494948"
    @ctx.fillRect(0,0,width,height)
    
    @ctx.globalCompositeOperation = "destination-out" # remove line
    perItem = width / (data.length - 1)
    @ctx.lineWidth = 1.8
    lastY = null
    first = (data.shift() / 100)
    [lastX,lastY] = [0, first * height]
    data.forEach (item,offset) ->
      x = perItem * (offset + 1)
      y = (item / 100) * height
      @ctx.beginPath()
      @ctx.moveTo lastX, lastY
      @ctx.lineTo x, y
      [lastX,lastY] = [x, y]
      @ctx.stroke()
      console.log x, y
    
    
    @ctx.globalCompositeOperation = "destination-over" # draw background
    grad = ctx.createLinearGradient(0,0,0,height)
    grad.addColorStop(0, '#6CFF3F')
    grad.addColorStop(1 / 2 , 'aqua')
    grad.addColorStop(1, '#40ACFF')
    @ctx.fillStyle=grad
    @ctx.fillRect(0,0,width,height)
    
document.addEventListener "DOMContentLoaded", ->
  RainbowSpark document.getElementById("graph"), data