# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

voteable_classes = '.post, .comment, .theme'

jQuery ->
  $('.upvote, .downvote').live 'click', (e) ->
    e.preventDefault()
    $(this).toggleClass('on')
    if $(this).hasClass('upvote')
      changePoints $(this), (if $(this).hasClass('on') then 1 else -1)
    else
      changePoints $(this), (if $(this).hasClass('on') then -1 else 1)
    true
    
changePoints = (e, points) ->
  points += updateSibling(e)
  span = e.parents(voteable_classes).find('.points')
  span.html(points + parseInt(span.html()))
  postToServer(e)

updateSibling = (e) ->
  if e.hasClass('upvote')
    sib = e.siblings('.downvote')
    p = 1
  else
    sib = e.siblings('.upvote')
    p = -1
  if sib.hasClass('on')
    sib.removeClass('on')
    p
  else
    0
    
postToServer = (e) ->
  $.post e.attr('href'), {
    dom_id:    e.parents(voteable_classes).attr('id'),
    direction: if e.hasClass('upvote') then 'up' else 'down',
    toggle:    if e.hasClass('on') then 'on' else 'off'
  }