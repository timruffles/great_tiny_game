

game = ->
  
  armEl = $("#arm")
  duelistEl = $("#duelist")
  canvas = $("<canvas width='800' height='800' />")
  ctx = canvas[0].getContext "2d"

  aim = 1/2 * Math.PI
  duelist =
    x: 300
    y: 200
    armLength: 30
    height: 100
    moving: true
    armAngle: 0
    armOffset:
      y: 150
      x: 150
    fired: false
  turnEl = null
  turned = ->
    $("<div id='turned'>Fire!</div>").appendTo(document.body)
    duelistEl.addClass "turned"
    document.addEventListener "mousedown", (evt) ->
      fired()
    turnEl.remove()
    fireEl = $("""
      <div id='turn'>
        <p class="command">
          Fire!
        </p>
        <ul class="help">
          <li>Click or touch to fire</li>
        </ul>
      </div>
    """).appendTo(document.body)
  fired = ->
    return if duelist.fired
    angle = duelist.armAngle

    duelist.fired = true
    $("<div id='fired'>Await the outcome...</div>").appendTo(document.body)
    duelistEl.remove()
  turn = ->
    turnEl = $("""
      <div id='turn'>
        <p class="command">
          Turn
        </p>
        <ul class="help">
          <li>Press any key to turn</li>
        </ul>
      </div>
    """).appendTo(document.body)

    document.addEventListener "keydown", (evt) ->
      return unless duelist.moving
      duelist.moving = false
      turned()


  {tan,sin,cos,asin,acos,atan2} = Math

  setInterval (->
    if duelist.moving
      duelist.x += 5
    duelistEl.css left: duelist.x
  ), 100


  setTimeout turn, 1000 + (Math.random() * 3000)
  
  console.log((duelist.x + duelist.armOffset.x))
  console.log((duelist.y + duelist.armOffset.y))

  lastEvt = null
  lastAngle = null
  originalRotation =  Math.PI * 0.5
  document.body.addEventListener "mousemove", (evt) ->
    [normalX,normalY]  = [
      evt.clientX - (duelist.x + duelist.armOffset.x + 20)
      evt.clientY - (duelist.y + duelist.armOffset.y)
    ]

    duelist.armAngle = (atan2(normalY, normalX) - originalRotation) 
    armEl.css("-webkit-transform":"rotate(#{duelist.armAngle}rad)")
 

document.addEventListener("DOMContentLoaded",game)




