Template.photoCollectionItem.rendered = ->
  @$(".photo-collection-item").hover (->
    editDeleteButtons = $(@).find('.hover-buttons')
    editDeleteButtons.css 'visibility', 'visible'
  ), ->
    editDeleteButtons = $(@).find('.hover-buttons')
    editDeleteButtons.css 'visibility', 'hidden'