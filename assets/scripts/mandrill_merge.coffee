window.MandrillMerge or= {}

class MandrillMergeApp
  constructor: ->
    @bindEvents()

  bindEvents: ->
    $('#hello-coffeescript').on('click', @greet)

  submit_my_form: (caller)->
    caller.parent().prev('form').submit()

  go_back: (caller)->
    alert 'watch this space'

$ ->
  window.MandrillMerge.app = new MandrillMergeApp()
  