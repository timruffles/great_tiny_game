(function() {
  var Threat, ThreatTrack, Threats, threatTpl;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  Threat = Model.extend();
  Threats = Collection.extend({
    constructor: function() {
      return _.bindAll(this, "tick");
    },
    model: Threat,
    tick: __bind(function() {
      if (this.length < 10) {
        return this.create({
          type: Threat.types.random(),
          level: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].random()
        });
      }
    }, this)
  });
  threatTpl = '<div class="threat {{type}}">\n  {{level}}\n</div>';
  ThreatTrack = View.Extend({
    events: {
      "click .threat": "handle"
    },
    initialize: function() {
      return _.bindAll(this, "render", "add");
    },
    render: function() {
      return this.collection.each(this.add);
    },
    add: function(threat) {
      return $(_.template(threatTpl, threat.attributes)).css({
        "top": "100%".appendTo(this.el)
      });
    },
    handle: function() {}
  });
}).call(this);
