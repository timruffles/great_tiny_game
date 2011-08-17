Model = Backbone.Model
Collection = Backbone.Collection
View = Backbone.View
countdownFn = (delay,repeats,each,end) ->
  if repeats == 0
    end() if end
  else
    each(repeats)
    setTimeout (-> countdownFn(delay,repeats - 1,each,end)), delay

Rhythm = Model.extend
  initialize: ->
    _.bindAll this, "start", "assign", "end"
  start: ->
    countdownFn @get("pulseMilli"),
                @get("pulse"),
                (pulse) => @trigger("pulse",pulse)
                @end
  end: ->
    @trigger "end"
    @set endedAt: new Date
    setTimeout @assign, @get("timeoutMilli")
  resolve: ->
    unless @get "resolvedAt"
      @set resolvedAt: new Date
      if @get "endedAt"
        @assign()
      else
        @bind "change:endedAt", @assign
  diff: ->
    Math.abs ((+@get "resolvedAt") || 0) - (+@get "endedAt")
  assign: ->
    @trigger if @diff() < @get "winMilli" then "win" else "lose"
RhythmView = View.extend
  events:
    click: "resolve"
  initialize: ->
    _.bindAll this, "resolve"
    @model.bind "win", =>  $(@el).html "YOU WIN! #{(@model.diff()/1000).toFixed(2)} seconds is great!"
    @model.bind "lose", => $(@el).html "You lose :( #{(@model.diff()/1000).toFixed(2)} seconds is too long"
    @model.bind "end", =>  $(@el).append "<span>Go!</span>"
    @model.bind "pulse", (pulseNo) =>
      pulseEl = $ "<li>#{pulseNo}</li>"
      pulseEl.appendTo @el
      countdownFn @model.get("pulseMilli") / 3,
                  3,
                  -> pulseEl.html(pulseEl.html() + ".")
  resolve: ->
    console.log "resolved"
    @model.resolve()
    
$ ->
  rhy = new Rhythm pulse: 3, pulseMilli: 1000, timeoutMilli: 1000, winMilli: 250
  view = new RhythmView
    model: rhy
    el: $("<div>").appendTo(document.body)
  rhy.start()