window.MandrillMerge or= {}

$.ajaxSetup cache: false

class MandrillMergeApp
  constructor: ->
    @initialize_foundation()
    @bindEvents()

  bindEvents: ->
    $('form[ajax-form]').submit (e) ->
        action = $(this).attr('action')
        params = $(this).serialize()
        callback = $(this).attr('ajax-callback')
        $.post(action, params).done((response) ->
          window['MandrillMerge'].app[callback] jQuery.parseJSON(response)
        ).fail (response) ->
          alert 'something went wrong'
        e.preventDefault()

  initialize_foundation: ->
    $(document).foundation()

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
  
