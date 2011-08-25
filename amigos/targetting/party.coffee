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
    <span class="portrait">
      {{name}}
    </span>
    <span class="item">
      {{item}}
    </span>
  """
  events: 
    ".portrait click": "change"
    ".action click": "trigger"
  initialize: ({@itemChooser}) ->
    _.bindAll this, "render","change","trigger"
    @model.bind "change", @render
    @render()
  render: ->
    @el.innerHTML = toHtml(@template,_.extend @model.toJSON(), item: @model.get("active")?.get("name"))
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
      <li data-id="{{id}}" class="item">{{name}}</option>
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
      
      
