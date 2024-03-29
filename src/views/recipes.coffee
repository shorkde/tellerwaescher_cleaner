$ ->
  window.FilterView = Backbone.View.extend({
    id: "FilterView"
    events:
      'keyup input':'keyLog'
    initialize: ->
      _.bindAll(this, 'render', 'getData', 'keyLog');
      console.log "###", @value
    keyLog: ->
      console.log "keylog"
      if typeof @keyTimeout != "undefined"
        window.clearTimeout(@keyTimeout)
      @keyTimeout = window.setTimeout(@getData, 500)

    getData: ->
      @collection.query.searchstring = $('input', @el).val()
      @collection.fetch()

    render: ->
      $(@el).html Mustache.to_html $("#FilterView-template").html(), { value: window.valueInput }

      return @
  })

  window.SearchView = Backbone.View.extend({
    template: Utility.create_template("#SearchView-template")

    initialize: ->
      window.ingrResultView = new IngrResultView collection: @collection
    render: ->
      console.log "search view render"
      $(@el).append(ingrResultView.render().el)

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
      @submitButtonView = new SubmitButtonView
      window.valueInput = @model.get("title")
      window.currentId = @model.get("id")

    render: ->
      $(@el).append @nutritionListView.render().el
      $(@el).append @EANListView.render().el
      $(@el).append @CatsListView.render().el
      $(@el).append @submitButtonView.render().el

      @nutritionListView.collection.query.searchstring = @model.get("title")
      @EANListView.collection.query.searchstring = @model.get("title")
      @CatsListView.collection.query.searchstring = ""

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
      $(".nutrItem:not(.selected)", @el).parent().remove()
      @collection.each (item) ->
        nutrition = new NutritionsListElementView(model: item)
        $("table#NutritionsResults").append nutrition.render().el

      return @
  })

  window.NutritionsListElementView = Backbone.View.extend({
    template: Utility.create_template("#NutritionsListViewElement-template")
    tagName: "tr"
    events:
      "click":"mark"
    initialize: ->
      _.bindAll(this, 'render');

    render: ->
      $(@el).html @template(@model.toJSON())

      return @

    mark: ->
      $(".nutrItem.selected").removeClass "selected"
      if $(".nutrItem", @el).hasClass "selected"
        $(".nutrItem", @el).removeClass "selected"
      else
        $(".nutrItem", @el).addClass "selected"
  })

  window.EANView = Backbone.View.extend({
    id: "EAN"
    className: "span4"
    initialize: ->
      _.bindAll(this, 'render');

      @filterView = new FilterView collection: @collection
      @listView = new EANListView collection: @collection
      @selectAllView = new SelectAllButtonView
      @deselectAllView = new DeselectAllButtonView
    render: ->
      $(@el).append "<h2>EAN</h2>"
      $(@el).append @filterView.render().el
      $(@el).append @selectAllView.render().el
      $(@el).append @deselectAllView.render().el
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
      $(".eanItem:not(.selected)", @el).parent().remove()
      @collection.each (item) ->
        ean = new EANListElementView(model: item)
        $("table#EANResults").append ean.render().el

      return @
  })

  window.EANListElementView = Backbone.View.extend({
    template: Utility.create_template("#EANListViewElement-template")
    tagName: "tr"
    events:
      "click":"mark"
    initialize: ->
      _.bindAll(this, 'render', 'mark');

    render: ->
      $(@el).html @template(@model.toJSON())

      return @

    mark: ->
      if $(".eanItem", @el).hasClass "selected"
        $(".eanItem", @el).removeClass "selected"
      else
        $(".eanItem", @el).addClass "selected"
  })


  window.CatsView = Backbone.View.extend({
    id: "Cats"
    className: "span4"
    initialize: ->
      _.bindAll(this, 'render');

      @filterView = new FilterView({collection: @collection, value: @value})
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
      $(".catItem:not(.selected)", @el).parent().remove()
      @collection.each (item) ->
        cats = new CatsListElementView(model: item)
        $("table#CatsResults").append cats.render().el

      return @
  })

  window.CatsListElementView = Backbone.View.extend({
    template: Utility.create_template("#CatsListViewElement-template")
    tagName: "tr"
    events:
      "click":"mark"
    initialize: ->
      _.bindAll(this, 'render', 'mark');

    render: ->
      $(@el).html @template(@model.toJSON())

      return @

    mark: ->
      if $(".catItem", @el).hasClass "selected"
        $(".catItem", @el).removeClass "selected"
      else
        $(".catItem", @el).addClass "selected"
  })

  window.SubmitButtonView = Backbone.View.extend({
    id: "submitButton"

    events:
      'click':'submit'

    initialize: ->
      _.bindAll(this, 'render', 'submit');

    render: ->
      $(@el).html "Submit"

      return @

    submit: ->
      #nutritionitems
      if $('.nutrItem.selected').length > 0 && $('.catItem.selected').length > 0

        cats = new Array()
        $('.catItem.selected').each (index) ->
          cats.push $(this).attr("data-id")

        eans = new Array()
        $('.eanItem.selected').each (index) ->
          eans.push $(this).attr("data-id")

        @submitModel = new SubmitModel()
        @submitModel.query.eans = eans
        @submitModel.query.ingredient_id = window.currentId
        @submitModel.query.ingredient_category_ids = cats
        @submitModel.query.nutrition_id = $('.nutrItem.selected').attr("data-id")
        @submitModel.save()

        $('#IngrResults tr.active').next().click()
        $('#IngrResults tr.active').prev().remove()
      else
        alert "Bitte alles auswählen"
  })

  window.SelectAllButtonView = Backbone.View.extend({
    tagName: "a"
    className: 'selectAll btn'
    events:
      'click':'selectAll'

    initialize: ->
      _.bindAll(this, 'render', 'selectAll');

    render: ->
      $(@el).html "all"

      return @

    selectAll: ->
      $('.eanItem').addClass("selected")

  })

  window.DeselectAllButtonView = Backbone.View.extend({
    tagName: "a"
    className: 'selectAll btn'
    events:
      'click':'deselectAll'

    initialize: ->
      _.bindAll(this, 'render', 'deselectAll');

    render: ->
      $(@el).html "none"

      return @

    deselectAll: ->
      $('.eanItem').removeClass("selected")

  })