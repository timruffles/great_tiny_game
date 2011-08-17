Threat = Model.extend()

Threats = Collection.extend
  constructor: ->
    _.bindAll this, "tick"
  model: Threat
  tick: =>
    if @length < 10
      @create
        type: Threat.types.random()
        level: [1..10].random()

threatTpl = '''
  <div class="threat {{type}}">
    {{level}}
  </div>
'''


ThreatTrack = View.Extend
  events:
    "click .threat": "handle"
  initialize: ->
    _.bindAll this, "render", "add"
  render: ->
    @collection.each @add
  add: (threat) ->
    $(_.template threatTpl, threat.attributes)
      .css "top": "100%"
      .appendTo @el
  handle: ->
