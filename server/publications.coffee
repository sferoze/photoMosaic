async = Meteor.npmRequire("async")

Meteor.publish null, ->
  Meteor.users.find({_id: this.userId}, {fields: {tags: 1, defaultEditor: 1}})

Meteor.publish 'myphotoBooks', (userId) ->
  if userId?
    PhotoBooks.find({$or: [{userId: userId}, {'collaborators.userId': userId}], trash: {$exists: false}})

# Meteor.publish 'photoBook', (userId, photoBookId) ->
#   if userId? and photoBookId?
#     PhotoBooks.find({ $and: [{$or: [{userId: userId}, {'collaborators.userId': userId}] }, {_id: photoBookId}] })


# This gets all photos associated with a photobook
Meteor.publish 'photosForPhotoBook', (photoBookId, userId, photoLimit) ->
  if userId? and photoBookId?
    photoBook = PhotoBooks.findOne({ $and: [{$or: [{userId: userId}, {'collaborators.userId': userId}] }, {_id: photoBookId}] })

    if photoBook? and !photoBook.trash?
      Photos.find({photoBookId: photoBook._id, trash: {$exists: false}}, {limit: photoLimit, sort: {date: -1}})
    else
      @error(new Meteor.Error(401, 'User does not have access to these photos'))