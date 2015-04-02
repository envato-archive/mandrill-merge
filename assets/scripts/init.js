$.ajaxSetup ({
   cache: false
});

jQuery(function() {
  $(document).foundation();

  $('form[ajax-form]').submit(function(e) {
    var action = $(this).attr('action');
    var params = $(this).serialize();
    var callback = $(this).attr('ajax-callback');

    $.post(action, params)
      .done(function(response) { window[callback](jQuery.parseJSON(response)); })
      .fail(function(response) { alert('something went wrong'); });

    e.preventDefault();
  });
});

function mandrill_connect_response(response) {
  $('.mandrill-connection-status').html(response.message);

  if (response.can_connect) {
    toggle_tab('select_template');
  }
}

function toggle_tab(name) {
  $('#' + name + '_header').click();
}
