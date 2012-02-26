jQuery(function($) {
  var $form = $('#regex_form')
  var $webhook_url = $('#webhook_url')
  var $preview = $('#preview')
  var $log_lines = $('#log_lines')
  var $regex = $('#regex')
  var $debug_info = $('#debug_info')

  function updateWebhookUrl() {
    $webhook_url.val(window.document.location + "submit?" + $form.serialize())
  }

  function updateTable() {
    if ($log_lines.val() == '' || $regex.val() == '') {
      $debug_info.show()
      $preview.hide()
      return
    }

    var data = $form.serializeArray().concat({ name: "lines", value: $log_lines.val() })

    $.post('/preview',
      data,
      function (data) {
        $preview.html(data)
        $debug_info.hide()
        $preview.show()
    })
  }

  $form.on("change keyup click", function() {
    updateWebhookUrl()
    updateTable()
  })

  $webhook_url.on("focus mouseup click keypress", function(e) {
    e.stopPropagation()
    e.preventDefault()
    $(this).select()
    return false
  })

  updateWebhookUrl()
});