$ ->
  window.FilterView = Backbone.View.extend({
    id: "FilterView"
    events:
      'keyup input':'keyLog'
    initialize: ->
      _.bindAll(this, 'render', 'getData', 'keyLog');

    keyLog: ->
      console.log "keylog"
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
      @ingrDetailView = new IngrDetailView({ model : @model })
      $('#container').html(@ingrDetailView.render().el)
  })

  window.IngrDetailView = Backbone.View.extend({
    className: "row-fluid"
    initialize: ->
      _.bindAll(this, 'render');

      @nutritionListView = new NutritionsView({ collection : new NutritionsCollection() })
      @EANListView = new EANView({ collection : new EANCollection() })
      @CatsListView = new CatsView({ collection : new CatsCollection() })

      @sendNutr = new sendNutrModel
      @sendEAN = new sendEANModel
      @sendCats = new sendCatsModel

    render: ->
      $(@el).append @nutritionListView.render().el
      $(@el).append @EANListView.render().el
      $(@el).append @CatsListView.render().el

      @nutritionListView.collection.query.searchstring = @model.get("title")
      @EANListView.collection.query.searchstring = @model.get("title")

      @nutritionListView.collection.fetch()
      @EANListView.collection.fetch()
      @CatsListView.collection.fetch()


      return @
  })

  window.NutritionsView = Backbone.View.extend({
    id: "Nutritions"
    className: "span4"
    initialize: ->
      _.bindAll(this, 'render');

      @filterView = new FilterView collection: @collection
      @listView = new NutritionsListView collection: @collection
    render: ->
      $(@el).append "<h2>Nährwerte</h2>"
      $(@el).append @filterView.render().el
      $(@el).append @listView.render().el

      return @
  })

  window.NutritionsListView = Backbone.View.extend({
    tagName: "table"
    className: "table table-striped table-bordered"
    id: "NutritionsResults"
    initialize: ->
      _.bindAll(this, 'render');
      @collection.bind "reset", @render
    render: ->
      console.log "render nutr"
      $(@el).html("")
      @collection.each (item) ->
        nutrition = new NutritionsListElementView(model: item)
        $("table#NutritionsResults").append nutrition.render().el

      return @
  })

  window.NutritionsListElementView = Backbone.View.extend({
    template: Utility.create_template("#NutritionsListViewElement-template")
    tagName: "tr"
    initialize: ->
      _.bindAll(this, 'render');

    render: ->
      $(@el).html @template(@model.toJSON())

      return @
  })

  window.EANView = Backbone.View.extend({
    id: "EAN"
    className: "span4"
    initialize: ->
      _.bindAll(this, 'render');

      @filterView = new FilterView collection: @collection
      @listView = new EANListView collection: @collection
    render: ->
      $(@el).append "<h2>EAN</h2>"
      $(@el).append @filterView.render().el
      $(@el).append @listView.render().el

      return @
  })

  window.EANListView = Backbone.View.extend({
    tagName: "table"
    className: "table table-striped table-bordered"
    id: "EANResults"
    initialize: ->
      _.bindAll(this, 'render');
      @collection.bind "reset", @render
    render: ->
      console.log "render nutr"
      $(@el).html("")
      @collection.each (item) ->
        ean = new EANListElementView(model: item)
        $("table#EANResults").append ean.render().el

      return @
  })

  window.EANListElementView = Backbone.View.extend({
    template: Utility.create_template("#EANListViewElement-template")
    tagName: "tr"
    initialize: ->
      _.bindAll(this, 'render');

    render: ->
      $(@el).html @template(@model.toJSON())

      return @
  })


  window.CatsView = Backbone.View.extend({
    id: "Cats"
    className: "span4"
    initialize: ->
      _.bindAll(this, 'render');

      @filterView = new FilterView collection: @collection
      @listView = new CatsListView collection: @collection
    render: ->
      $(@el).append "<h2>Categories</h2>"
      $(@el).append @filterView.render().el
      $(@el).append @listView.render().el

      return @
  })

  window.CatsListView = Backbone.View.extend({
    tagName: "table"
    className: "table table-striped table-bordered"
    id: "CatsResults"
    initialize: ->
      _.bindAll(this, 'render');
      @collection.bind "reset", @render
    render: ->
      console.log "render nutr"
      $(@el).html("")
      @collection.each (item) ->
        cats = new CatsListElementView(model: item)
        $("table#CatsResults").append cats.render().el

      return @
  })

  window.CatsListElementView = Backbone.View.extend({
    template: Utility.create_template("#CatsListViewElement-template")
    tagName: "tr"
    initialize: ->
      _.bindAll(this, 'render');

    render: ->
      $(@el).html @template(@model.toJSON())

      return @
  })
