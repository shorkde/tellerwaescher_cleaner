$ ->
  window.FilterView = Backbone.View.extend({
    id: "FilterView"
    events:
      'keyup input#searchForm':'keyLog'
    initialize: ->
      _.bindAll(this, 'render', 'getData');

    keyLog: ->
      if typeof @keyTimeout != "undefined"
        window.clearTimeout(@keyTimeout)
      @keyTimeout = window.setTimeout(@getData, 500)

    getData: ->
      @collection.query.searchstring = $('input', @el).val()
      @collection.fetch()

    render: ->
      $(@el).html Mustache.to_html $("#FilterView-template").html(), null

      return @
  })

  window.SearchView = Backbone.View.extend({
    template: Utility.create_template("#SearchView-template")

    initialize: ->
      @recipeResultView = new IngrResultView collection: @collection
    render: ->
      console.log "search view render"
      $(@el).append(@recipeResultView.render().el)

      @collection.fetch()

      return @
  })

  window.IngrResultView = Backbone.View.extend({
    tagName: "table"
    className: "table table-striped table-bordered"
    id: "IngrResults"
    initialize: ->
      _.bindAll(this, 'render');
      @collection.bind "reset", @render

    render: ->
      $(@el).html("")
      @collection.each (item) ->
        console.log "iterate"
        ingr = new IngrListElementView(model: item)
        $("table#IngrResults").append ingr.render().el

      return @
  })

  window.IngrListElementView = Backbone.View.extend({
    template: Utility.create_template("#IngredientListViewElement-template")
    tagName: "tr"
    events:
      'click' : 'showDetails'
    initialize: ->
      _.bindAll(this, 'render', 'showDetails');

    render: ->
      $(@el).html @template(@model.toJSON())

      return @

    showDetails: ->
      $('table#IngrResults tr').removeClass("active")
      $(@el).addClass("active")
      @recipeDetailView = new IngrDetailView({ model : @model })
      $('#container').html(@recipeDetailView.render().el)
  })

  window.IngrDetailView = Backbone.View.extend({
    template: Utility.create_template("#IngredientDetailView-template")
    initialize: ->
      _.bindAll(this, 'render');

    render: ->
      $(@el).html @template(@model.toJSON())

      return @
  })