jQuery -> 
  # if $('.flash').length
  #   $('.flash').delay(3000).fadeOut('slow')
  
  $('.flash .alert .close').click ->
    $(this).parent('.alert').fadeOut('fast')