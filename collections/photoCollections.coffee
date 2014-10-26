@PhotoBooks = new Mongo.Collection('photobooks')

PhotoBooks.allow
  update: collabOfDocument
  remove: ownsDocument


Meteor.methods 
  addPhotoBook: () ->

    params =
      name: 'Untitled Photo Book'
      createdAt: new Date()
      userId: Meteor.userId()
      collaborators: []
      pictureQuality: 80
      public: false

    id = PhotoBooks.insert params

  # removePendingCollab: () ->

  # addCollab: () ->

  # removeCollab: () ->

  # movePhotoBookToTrash: (_id) ->

  # restorePhotoBook: (_id) ->

  # removePhotoBook: (_id) ->

  # acceptCollab: (params) ->

  # denyCollab: (params) ->

  # 