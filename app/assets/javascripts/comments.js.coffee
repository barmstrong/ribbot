jQuery ->
  $('.reply-link').live 'click', (e) ->
    $('.comment .comment-form').remove()
    comment = $(this).parents('.comment')
    form = $('#reply_comment form').clone().hide()
    comment.append(form)
    form.fadeIn('fast')
    comment.find('form #comment_parent_id').val(comment.attr('id').split('_')[1])
    form.find('textarea').focus()
    false
    
  $('.cancel-link').live 'click', (e) ->
    comment = $(this).parents('.comment')
    $('.comment .comment-form').fadeOut('fast')
    false
    