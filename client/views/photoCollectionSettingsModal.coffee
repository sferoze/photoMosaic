Template.photoCollectionSettingsModal.helpers 
  photoCollectionOwner: ->
    @userId is Meteor.userId()


Template.photoCollectionSettingsModal.rendered = ->
  console.log 'test'
  t = @

  savePhotoCollectionTitle = _.debounce () ->
    title = t.$('#photoCollectionName').val()
    if title.length > 0 and title.length < 25
      PhotoCollections.update t.data._id,
        $set:
          name: title
      , (error) ->
        if error
          FlashMessages.sendError 'Could not save name of photo collection, please contact support'
        else
          console.log 'saved photo collection name'
  , 400

  @$('#photoCollectionName').on 'input', ->
    savePhotoCollectionTitle()