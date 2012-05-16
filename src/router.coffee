#TODO
#- search View:

$ ->
  window.Admin = Backbone.Router.extend(
    routes:
      "": "main"
      "ingredient/:id": "ingr"

    initialize: ->
      Backbone.history.start pushState: false

      $('#btn-back').live 'click', ->
        console.log "back clicked"
        window.history.back()

    main: ->
      console.log "main"
      @searchView = new SearchView({ collection: new IngredientsCollection() });

      $('#ingr_list').html(@searchView.render().el)
      #@dashboardView = new DashboardView();
      #$('#main_container').html(@dashboardView.render().el)

    ingr: (id) ->
      console.log "ingr"+id

      @recipeDetailView = new IngrDetailView({});
      #@recipeDetailView.model.fetch()
      $('#container').html(@recipeDetailView.render().el)

    map: (id) ->
      console.log "map"+id
  )