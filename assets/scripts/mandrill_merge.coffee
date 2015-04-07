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

  select_template: (response)->
    $('#mandrill-template-status').html response.message
    window.MandrillMerge.app.toggle_section 'connect_db'

  db_connect_response: (response)->
    $('#db-connection-status').html response.message
    if response.can_connect
      window.MandrillMerge.app.toggle_section 'select_data'

  set_db_query_response: (response)->
    window.MandrillMerge.app.toggle_section 'sub_query'

  toggle_section: (name)->
    $('#' + name + '_header').click();  

$ ->
  window.MandrillMerge.app = new MandrillMergeApp()
  
