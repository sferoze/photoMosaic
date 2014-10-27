@Notifications = new Meteor.Collection("notifications")

Notifications.allow 
  update: ownsDocument
  remove: ownsDocument


@createRequestCollaboratorNotification = (params) ->
  Notifications.insert
    userId: params.userId
    username: params.username
    photoBookId: params.photoBookId
    photoBookName: params.photoBookName
    requesterId: params.requesterId
    requesterUsername: params.requesterUsername
    type: params.type
    read: false

@createBasicNotification = (params) ->
  Notifications.update
    userId: params.userId
    msg: params.msg
    type: 'basic'
    read: false
  ,
    $inc:
      qty: 1
  ,
    upsert: true