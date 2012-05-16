$ ->
  MyBackboneCollection = Backbone.Collection.extend
    sync: (method, model, options) ->
    #set the type
      if typeof @type == "undefined"
        @type = "POST"

      #set the url
      if typeof @url == "function"
        options.url = @url()
      else
        options.url = @url

      #set the params
      if !@noJsonStringify
        options.data =
          request: JSON.stringify(@query)
      else
        options.data = @query

      params = {type: @type, dataType: 'json'};

      return $.ajax(_.extend(params, options));

  window.IngredientsCollection = MyBackboneCollection.extend
    model: IngredientModel
    query:
      searchstring: ""
      limit: 10
      offset: 0
    url: "/api/get_unlinked_ingredients/"
    type: "GET"

  window.NutritionsCollection = MyBackboneCollection.extend
    model: NutritionModel
    query:
      searchstring: ""
      limit: 10
      offset: 0
    url: "/api/search_ingredient_info/"

  window.EANCollection = MyBackboneCollection.extend
    model: EANModel
    query:
      searchstring: ""
      limit: 10
      offset: 0
    url: "/api/get_eans/"

  window.CatsCollection = MyBackboneCollection.extend
    model: CatModel
    query:
      searchstring: ""
      limit: 10
      offset: 0
    url: "/api/get_ingredient_categories/"
    type: "GET"

