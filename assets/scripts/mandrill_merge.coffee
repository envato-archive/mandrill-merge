window.MandrillMerge or= {}

class MandrillMergeApp
  constructor: ->
    @bindEvents()

  bindEvents: ->
    $('#hello-coffeescript').on('click', @greet)

  submit_my_form: (caller)->
    caller.parent().prev('form').submit()

  go_back: (caller)->
    caller.parents('.accordion-navigation').prev().find('a').click()

  mandrill_connect_response: (response)->
    $('#mandrill-connection-status').html response.message
    if response.can_connect
      window.MandrillMerge.app.toggle_section 'select_template'
    return  

  select_template: (response)->
    $('#mandrill-template-status').html response.message

  toggle_section: (name)->
    $('#' + name + '_header').click();  

$ ->
  window.MandrillMerge.app = new MandrillMergeApp()
  