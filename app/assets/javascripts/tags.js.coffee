jQuery ->
  $('#tags tbody').sortable(
    axis: 'y'
    handle: '.handle'
    update: ->
      $.post($('#tags').data('update-url'), $(this).sortable('serialize'))
    helper: (e, tr) ->
      $originals = tr.children()
      $helper = tr.clone()
      $helper.children().each (index) ->
        $(this).width($originals.eq(index).width())
      $helper
  )
  
  $('#tags').hide() if $('#tags tbody tr').length == 0
  
  $('#tags .edit-tag-link').live 'click', (e) ->
    tr = $(this).parents('tr')
    tr.find('.show').hide()
    tr.find('.edit').fadeIn('fast')
    
  $('#tags .cancel-edit-tag-link').live 'click', (e) ->
    tr = $(this).parents('tr')
    tr.find('.edit').hide()
    tr.find('.show').fadeIn('fast')
    
  $('.post-form .tag-link').click (e) ->
    $(this).toggleClass('active')
    checkbox = $(this).siblings('.tag-checkbox')
    checkbox.attr('checked', !checkbox.attr('checked'))
    false