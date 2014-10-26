# the jade page for photoBookItem is in dashboard.jade

Template.photoBookItem.rendered = ->
  @$(".photo-book-item").hover (->
    editDeleteButtons = $(@).find('.hover-buttons')
    editDeleteButtons.css 'visibility', 'visible'
  ), ->
    editDeleteButtons = $(@).find('.hover-buttons')
    editDeleteButtons.css 'visibility', 'hidden'