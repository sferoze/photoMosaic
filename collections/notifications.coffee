@Notifications = new Meteor.Collection("notifications")

Notifications.allow 
  update: ownsDocument
  remove: ownsDocument


@createRequestCollaboratorNotification = (params) ->
  Notifications.insert
    userId: params.userId
    username: params.username
    photoBookId: params.threadId
    photoBookName: params.threadName
    requesterId: params.requesterId
    requesterUsername: params.requesterUsername
    type: params.type
    read: false

