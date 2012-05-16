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

  window.RecipeSearchCollection = MyBackboneCollection.extend
    model: RecipeModel
    query:
      searchstring: ""
      limit: 10
      offset: 0
    url: "/api/ios/search_recipe/"