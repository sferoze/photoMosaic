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

  addCollab: (username, photoBookId, photoBookName) ->
    #I might have to move this function to Meteor.isServer when I stop publishing all users to client
    user = Meteor.users.findOne
      username: username
    if user?
      userOb =
        userId: user._id
      PhotoBooks.update photoBookId, 
        $addToSet: 
          'pending.collaborators': userOb

      params =
        userId: user._id
        username: user.username
        photoBookId: photoBookId
        photoBookName: photoBookName
        requesterId: Meteor.userId()
        requesterUsername: Meteor.user().username
        type: 'requestCollabForPhotoBook'

      # This is a global function defined in collections/notifications.coffee
      createRequestCollaboratorNotification params
    else 
      console.log 'user does not exist'
      throw new Meteor.Error(304, "User with that email does not exist")

  removeCollab: (userId, photoBookId) ->
    PhotoBooks.update photoBookId,
      $pull:
        'pending.collaborators':
          userId: userId
    , (error) ->
      if error
        throw new Meteor.Error(304, 'could not remove pending collab, contact support')

    Notifications.remove
      userId: userId
      photoBookId: photoBookId
      type: 'requestCollabForPhotoBook'
    , (error) ->
      if error
        throw new Meteor.Error(304, 'could not remove pending collab notification, contact support')

  movePhotoBookToTrash: (_id) ->
    PhotoBooks.update _id,
      $set:
        trash: true
    , (error) ->
      if error
        throw new Meteor.Error(304, 'could not move this photobook to the trash, contact support')


  restorePhotoBook: (_id) ->
    PhotoBooks.update _id, 
      $unset: 
        trash: ""
    , (error) ->
      if error
        throw new Meteor.Error(304, 'could not restore this photobook from the trash, contact support')

  removePhotoBook: (_id) ->
    PhotoBooks.remove _id, (error) ->
      if error
        throw new Meteor.Error(304, 'could not delete this photobook, contact support')
      else
        Photos.remove 
          photoBookId: _id
        , (error) ->
          if error
            throw new Meteor.Error(304, 'could not delete the photos associated with the deleted photobook, contact support')

  acceptCollab: (params) ->
    Notifications.update {_id: params._id},
      $set:
        read: true

    userOb =
      userId: params.userId
    Research.update {_id: params.photoBookId},
      $addToSet: 
        collaborators: userOb
    , (error, numberOfDocsAffected) ->
      if error
        #Errors.throw('Could not add collaborator to notepad')
        if Meteor.isClient
          FlashMessages.sendError('Could not add collaborator to photobook, please contact support and refresh', { autoHide: false })
      else
        acceptCollabNotifParams =
          userId: params.requesterId
          msg: params.username +  ' has accepted your collaboration request for the photobook ' + params.photoBookName
        createBasicNotification acceptCollabNotifParams


  denyCollab: (params) ->
    Notifications.update params._id,
      $set:
        read: true
    PhotoBooks.update {_id: params.photoBookId}, {$pull: {'pending.collaborators': {userId: params.userId}}}, (error, numberOfDocsAffected) ->
      if error
        #Errors.throw('Could remove collaborator from pending')
        if Meteor.isClient
          FlashMessages.sendError('Could remove collaborator from pending', { autoHide: false })
      else
        denyCollabNotifParams =
          userId: params.requesterId
          msg: params.username +  ' has denied your collaboration request for the photobook ' + params.photoBookName
        createBasicNotification denyCollabNotifParams

  # 