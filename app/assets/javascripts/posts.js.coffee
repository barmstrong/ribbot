jQuery ->
  $('form.post-form .url-link').click (e) ->
    $('#post_text').hide()
    $('#post_url').fadeIn('fast')
    $('.url-link').addClass('active')
    $('.text-link').removeClass('active')
    false

  $('form.post-form .text-link').click (e) ->
    $('#post_url').hide()
    $('#post_text').fadeIn('fast')
    $('.text-link').addClass('active')
    $('.url-link').removeClass('active')
    false
  