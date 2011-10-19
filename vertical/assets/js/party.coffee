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
    <div>
      <img class="portrait" src="assets/img/{{portrait}}.png" />
      {{name}}
    </div>
    {{#item}}
      <span class="active_item {{type}}">
        {{name}}
      </span>
    {{/item}}
    <button class="choose">
      Change item
    </button>
  """
  events: 
    ".choose click": "change"
    ".portrait click": "activate"
  initialize: ({@itemChooser}) ->
    _.bindAll this, "render","change","activate"
    @model.bind "change", @render
    @render()
  render: ->
    @el.innerHTML = toHtml(
      @template,
      _.extend @model.toJSON(), 
               item: @model.get("active")?.toJSON()
    )
  change: ->
    p "change"
    @pub.trigger "rpg:enter"
    @itemChooser.model = @model
    @itemChooser.render()
    @itemChooser.toggle(true)
  activate: ->
    if @model.get "active"
      @trigger "activate", @model.get("active")
    
idEvent = (fn) ->
  (evt) ->
    id = Number(evt.target.getAttribute("data-id"))
    fn.call(this,id,evt.target)
    
ItemChooser = View.extend
  className: "chooser"
  template: """
    {{#items}}
      <li data-id="{{id}}" class="item {{type}}">{{name}}</option>
    {{/items}}
  """
  initialize: ->
    _.bindAll this, "select"
  render: ->
    @el.innerHTML = toHtml(@template,items: @model.items.toJSON())
  events:
    ".item click": "select"
  select: idEvent (id) ->
    @model.select(id)
    @toggle(false)
    @pub.trigger "rpg:exit"
  toggle: (onOff) ->
    Z(@el).toggleClass "hidden", !onOff
      
      
