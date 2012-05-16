#TODO
#- search View:

$ ->
  window.Admin = Backbone.Router.extend(
    routes:
      "": "search"
      "search_ingr": "search_ingr"
      "recipe/:id": "recipe"
      "map/:id": "map"

    initialize: ->
      Backbone.history.start pushState: false

      $('#btn-back').live 'click', ->
        console.log "back clicked"
        window.history.back()

    search: ->
      console.log "search sdf"
      @searchView = new SearchView({ collection: new RecipeSearchCollection() });

      $('#container').html(@searchView.render().el)
      #@dashboardView = new DashboardView();
      #$('#main_container').html(@dashboardView.render().el)

    search_ingr: ->
      console.log "search_ingr"

    recipe: (id) ->
      console.log "recipe"+id

      @recipeDetailView = new RecipeDetailView({model: new RecipeDetailModel({id: id})});
      @recipeDetailView.model.fetch()
      $('#container').html(@recipeDetailView.render().el)

    map: (id) ->
      console.log "map"+id
  )