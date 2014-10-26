@Photos = new Mongo.Collection('photos')

Photos.allow
  update: ownsDocument
  remove: ownsDocument

Meteor.methods

  savePhoto: (blob, position, userId, photoBookId) ->
    postData =
      userId: userId
      blob: blob
      position: position
      photoBookId: photoBookId

    Photos.insert postData
