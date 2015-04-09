window.MandrillMerge or= {}

$.ajaxSetup cache: false

class MandrillMergeApp
  constructor: ->
    @initialize_foundation()
    @initialize_preview()
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

  initialize_preview: ->
    source = $('#preview-template').html()
    @previewTemplate = Handlebars.compile(source)

  submit_my_form: (caller)->
    caller.parent().prev('form').submit()

  go_back: (caller)->
    caller.parents('.accordion-navigation').prev().find('a').click()

  go_forward: (caller)->
    caller.parents('.accordion-navigation').next().find('a').click()

  mandrill_connect_response: (response)->
    $('#mandrill-connection-status').html response.message

    MandrillMerge.app.clear_section_status('connect_mandrill')
    if response.can_connect
      MandrillMerge.app.mark_section_complete('connect_mandrill')
      MandrillMerge.app.toggle_section 'select_template'
    else
      MandrillMerge.app.mark_section_error('connect_mandrill')

  select_template: (response)->
    $('#mandrill-template-status').html response.message
    MandrillMerge.app.clear_section_status('select_template')
    if response.success
      MandrillMerge.app.mark_section_complete('select_template')
      MandrillMerge.app.toggle_section 'connect_db'
    else
      MandrillMerge.app.mark_section_error('select_template')

  db_connect_response: (response)->
    $('#db-connection-status').html response.message

    MandrillMerge.app.clear_section_status('connect_db')
    if response.can_connect
      MandrillMerge.app.mark_section_complete('connect_db')
      MandrillMerge.app.toggle_section 'select_data'
    else
      MandrillMerge.app.mark_section_error('connect_db')

  preview_db_query: (response)->
    $('#data-query-status').html response.message
    if response.success
      preview_data = @previewTemplate(response.data)
    else
      preview_data = 'no data to preview'
    $('#db-query-preview').html preview_data

  set_db_query_response: (response)->
    $('#data-query-status').html response.message

    MandrillMerge.app.clear_section_status('select_data')
    if response.success
      MandrillMerge.app.mark_section_complete('select_data')
      MandrillMerge.app.toggle_section 'sub_query'
    else
      MandrillMerge.app.mark_section_error('select_data')

  test_sent: (response)->
    $('#test-status').html response.message
    MandrillMerge.app.toggle_section 'go'

  toggle_section: (name)->
    $('#' + name + '_header').click();  

  mark_section_complete: (name)->
    $('#' + name + '_header').parent().addClass('complete')

  mark_section_error: (name)->
    $('#' + name + '_header').parent().addClass('error')

  clear_section_status: (name)->
    $('#' + name + '_header').parent().removeClass('complete error')


$ ->
  window.MandrillMerge.app = new MandrillMergeApp() 
