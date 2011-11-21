jQuery ->
  setTimeout ->
    $('.right-sidebar, .left-sidebar').each (i, e) ->
      row_height = $(e).parent('.row').height()
      $(e).height(row_height)
  , 5
  
  if $('.flash').length
    $('.flash').delay(3000).fadeOut('slow')