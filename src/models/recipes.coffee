$ ->
  MyBackboneModel = Backbone.Model.extend({
    sync: (method, model, options) ->
      console.log "####"
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
  })

  window.IngredientModel = Backbone.Model.extend({
    initialize: ->
      console.log "recipe model init"
    parse: (response) ->
      if typeof response.pictures[0] != "undefined"
        response.picture = response.pictures[0]["ipad"]["96x96"]
      else
        response.picture = "images/default.png"
      return response
  })