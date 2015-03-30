class ExampleApp
  constructor: ->
    @bindEvents()

  bindEvents: ->
    $('#hello-coffeescript').on('click', @greet)

  greet: ->
    alert 'Hello from Coffee Script!'

$ ->
  app = new ExampleApp()