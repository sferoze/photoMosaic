Template.notifications.helpers
  notifications: ->
    Notifications.find
      userId: Meteor.userId()
      read: false


  notificationCount: ->
    Notifications.find(
      userId: Meteor.userId()
      read: false
    ).count()

Template.notification.helpers
  basicNotification: ->
    @type is 'basic' and @msg?
  requestCollabForPhotoBook: ->
    @type is 'requestCollabForPhotoBook'
  collabRequestResponse: ->
    @type is 'collabAccepted' or @type is 'collabDenied'

Template.notification.events "click .hover": ->
  Notifications.update @_id,
    $set:
      read: true

Template.basicNotif.helpers
  moreThanOneNotifAction: ->
    @qty > 1

Template.requestCollabNotif.events
  'click .accept-collab': (e) ->
    console.log 'accept'
    console.log @
    #remove userId from pending collaborators
    #add userId to collaborators array
    Meteor.call 'acceptCollab', @, (err) ->
      if err
        console.log err
      else
        console.log 'collab accepted'

  'click .deny-collab': (e) ->
    console.log 'deny'
    Meteor.call 'denyCollab', @, (err) ->
      if err
        console.log err
      else
        console.log 'collab denied'


