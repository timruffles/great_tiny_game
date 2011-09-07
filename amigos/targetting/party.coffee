Number::times = (fn) ->
  time = 1
  fn(time) until time++ >= this

Member = Model.extend
  initialize: (attrs,{@items}) ->
  select: (id) ->
    @set active: @items.get(id)
  toString: -> "Member"

Item = Model.extend
  toString: -> "Item"


MemberView = View.extend
  className: "member"
  template: """
    <div class="portrait">
      <img src="img/{{name}}.png" />
      {{name}}
    </div>
    {{#item}}
      <span class="item" style="color:{{color}}">
        {{name}}
      </span>
    {{/item}}
    <span class="choose">
        Edit
    </span>
  """
  events: 
    ".choose click": "change"
    ".portrait click": "trigger"
  initialize: ({@itemChooser}) ->
    _.bindAll this, "render","change","trigger"
    @model.bind "change", @render
    @render()
  render: ->
    @el.innerHTML = toHtml(@template,_.extend @model.toJSON(), item: @model.get("active")?.toJSON())
  change: ->
    p "change"
    @itemChooser.model = @model
    @itemChooser.render()
    @itemChooser.toggle()
  trigger: ->
    @model.get("active").trigger()
    
idEvent = (fn) ->
  (evt) ->
    id = Number(evt.target.getAttribute("data-id"))
    fn.call(this,id,evt.target)
    
ItemChooser = View.extend
  className: "chooser"
  template: """
    {{#items}}
      <li data-id="{{id}}" class="item" style="border: 2px solid {{color}}">{{name}}</option>
    {{/items}}
  """
  initialize: ->
    _.bindAll this, "select"
    @toggle()
  render: ->
    @el.innerHTML = toHtml(@template,items: @model.items.toJSON())
  events:
    ".item click": "select"
  select: idEvent (id) ->
    @model.select(id)
    @toggle()
  toggle: ->
    @el.classList.toggle "hidden"
      
      
