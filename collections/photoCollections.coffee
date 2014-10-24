@PhotoCollections = new Mongo.Collection('photocollections')

PhotoCollections.allow
  update: collabOfDocument
  remove: ownsDocument


Meteor.methods 
  addPhotoCollection: () ->

    params =
      name: 'Untitled Photo Collection'
      createdAt: new Date()
      userId: Meteor.userId()
      collaborators: []
      pictureQuality: 80
      public: false

    id = PhotoCollections.insert params
  