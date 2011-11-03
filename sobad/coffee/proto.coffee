

game = ->
  
  armEl = $("#arm")
  duelistEl = $("#duelist")

  aim = 1/2 * Math.PI
  duelist =
    x: 300
    y: 200
    armLength: 30
    height: 100
    moving: true
    armAngle: 0
    armOffset:
      y: 180
      x: 180



  turned = ->
    $("<div id='turned'>Fire!</div>").appendTo(document.body)
  fired = ->
    $("<div id='fired'>Await the outcome...</div>").appendTo(document.body)
  turn = ->
    $("<div id='turn'>Turn</div>").appendTo(document.body)

    document.body.addEventListener "keydown", (evt) ->
      duelist.moving = false if evt.keyCode == 65
      turned()

    document.body.addEventListener "mousedown", (evt) ->
      fired()

  {tan,sin,cos,asin,acos,atan2} = Math

  setInterval (->
    duelist.x += 5 if duelist.moving
    duelistEl.css left: duelist.x
    armEl.css left: parseInt(armEl.css("left")) + 5

  ), 100


  setTimeout turn, 1000 + (Math.random() * 3000)
  
  lastEvt = null
  lastAngle = null
  document.body.addEventListener "mousemove", (evt) ->
    [normalX,normalY]  = [evt.offsetX - (duelist.x + duelist.armOffset.x),evt.offsetY - (duelist.y + duelist.armOffset.y)]

    duelist.armAngle = atan2 normalY, normalX

    armEl.css("-webkit-transform":"rotate(#{duelist.armAngle}rad)")
 

document.addEventListener("DOMContentLoaded",game)




