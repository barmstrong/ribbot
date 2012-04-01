jQuery ->
  $('#pages tbody').sortable(
    axis: 'y'
    handle: '.handle'
    update: ->
      $.post($('#pages').data('update-url'), $(this).sortable('serialize'))
    helper: (e, tr) ->
      $originals = tr.children()
      $helper = tr.clone()
      $helper.children().each (index) ->
        $(this).width($originals.eq(index).width())
      $helper
  )

  $('form.page-form .url-link').click (e) ->
    $('#text_container').hide()
    $('#url_container').fadeIn('fast')
    $('.url-link').addClass('active')
    $('.text-link').removeClass('active')
    false

  $('form.page-form .text-link').click (e) ->
    $('#url_container').hide()
    $('#text_container').fadeIn('fast')
    $('.text-link').addClass('active')
    $('.url-link').removeClass('active')
    false