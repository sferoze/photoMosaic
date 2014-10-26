Template.photoBookSettingsModal.helpers 
  photoBookOwner: ->
    @userId is Meteor.userId()


Template.photoBookSettingsModal.rendered = ->
  console.log 'test'
  t = @

  savePhotoBookName = _.debounce () ->
    title = t.$('#photoBookName').val()
    if title.length > 0 and title.length < 25
      PhotoBooks.update t.data._id,
        $set:
          name: title
      , (error) ->
        if error
          FlashMessages.sendError 'Could not save name of photo book, please contact support'
        else
          console.log 'saved photo book name'
  , 400

  @$('#photoBookName').on 'input', ->
    savePhotoBookName()