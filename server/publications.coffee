async = Meteor.npmRequire("async")

Meteor.publish null, ->
  Meteor.users.find({_id: this.userId}, {fields: {tags: 1, defaultEditor: 1}})

Meteor.publish 'myPhotoCollections', (userId) ->
  if userId?
    PhotoCollections.find({$or: [{userId: userId}, {'collaborators.userId': userId}], trash: {$exists: false}})

# This gets all photos associated with a collection
Meteor.publish 'collectionPhotos', (collectionId, id, photoLimit) ->
  if id? and collectionId?
    collection = PhotoCollections.findOne({ $and: [{$or: [{userId: id}, {'collaborators.userId': id}] }, {_id: collectionId}] })

    if collection? and !collection.trash?
      Photos.find({collectionId: collectionId, trash: {$exists: false}}, {limit: photoLimit, sort: {date: -1}})
    else
      @error(new Meteor.Error(401, 'User does not have access to these photos'))