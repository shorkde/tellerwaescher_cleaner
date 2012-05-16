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

  window.RecipeModel = Backbone.Model.extend({
    initialize: ->
      console.log "recipe model init"
    parse: (response) ->
      if typeof response.pictures[0] != "undefined"
        response.picture = response.pictures[0]["iphone"]["120x120"]
      else
        response.picture = "images/default.png"
      return response
  })

  window.RecipeDetailModel = Backbone.Model.extend({
    url: ->
      return "/api/ios/get_recipe/"+@id+"/"
    parse: (res) ->
      if typeof res.pictures[0] != "undefined"
        res.picture = res.pictures[0]["iphone"]["120x120"]
      else
        res.picture = "images/default.png"

      res.parts = Utility.format_steps(res.parts)
      return res
  })