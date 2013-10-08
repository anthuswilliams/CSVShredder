```coffeescript
$ ->
  $('#div-upload').CSVParser({
    'enclosedBy' : '"'
    'onLoad' : (f, i) ->
      $('#div-upload > #instructions').hide()
      indicator = $('#file-block-default').last().clone()
      indicator.removeClass('hidden').addClass('file-block').attr('id','file-block-' + i).prependTo('#div-upload')
      indicator.find('.file-name').text(f.name)
      $('#div-upload').attr('style','height: ' + (110 * (Math.floor($('.file-block').length / 5) + 1 )) + 'px') # resize container div -- TODO: replace this ugly hack with something nicer
    'onConstruct' : (obj) ->
      if obj.array.length
        $('#total-lines').removeClass('hidden').text obj.array.length
        $('#total-fields').removeClass('hidden').text obj.fields.length
      $('#div-results').removeClass('hidden')
      $('#div-results table').html '<thead><tr></tr></thead><tbody></tbody>'
      # IF we are to use the first line as headers
      for field in obj.fields
        $('#div-results table thead tr').append('<th>' + field + '</th>')
      for row in obj.array
        tr = []
        for field in row
          tr.push '<td>' + field + '</td>'
        $('#div-results table tbody').append(('<tr>'+ tr.join(' ')) + '</tr>')
  })

```
