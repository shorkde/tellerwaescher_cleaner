$ ->
  window.App = new Admin()

  $('form').live "submit", (e) ->
    e.preventDefault()