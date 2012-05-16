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
      @recipeResultView = new RecipeResultView collection: @collection
      @filterView = new FilterView collection: @collection
    render: ->
      console.log "search view render"
      $(@el).append(@filterView.render().el)
      $(@el).append(@recipeResultView.render().el)

      @collection.fetch()

      return @
  })

  window.RecipeResultView = Backbone.View.extend({
    tagName: "table"
    className: "table table-striped table-bordered"
    id: "RecipeResults"
    initialize: ->
      _.bindAll(this, 'render');
      @collection.bind "reset", @render

    render: ->
      $(@el).html("")
      @collection.each (item) ->
        console.log "iterate"
        ingr = new RecipeListElementView(model: item)
        $("table#RecipeResults").append ingr.render().el

      return @
  })

  window.RecipeListElementView = Backbone.View.extend({
    template: Utility.create_template("#RecipeListViewElement-template")
    tagName: "tr"
    initialize: ->
      _.bindAll(this, 'render');

    render: ->
      $(@el).html @template(@model.toJSON())

      return @
  })

  window.RecipeDetailView = Backbone.View.extend({
    initialize: ->
      _.bindAll(this, 'render');
      @topBarView = new TopBarView()
      @recipeDataView = new RecipeDataView model:@model

    render: ->
      $(@el).append @topBarView.render().el
      $(@el).append @recipeDataView.render().el

      return @
  })

  window.RecipeDataView = Backbone.View.extend({
    template: Utility.create_template("#RecipeDataView-template")
    id: "recipeData"
    initialize: ->
      _.bindAll(this, 'render');
      @model.bind "change", @render

    render: ->
      $(@el).html @template(@model.toJSON())

      return @
  })

  window.TopBarView = Backbone.View.extend({
    template: Utility.create_template("#TopBarView-template")
    id: "topbar"
    initialize: ->
      _.bindAll(this, 'render');

    render: ->
      $(@el).html @template(null)

      return @
  })