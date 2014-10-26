Template.addCollabModal.events
  'click .remove-pending-collab': (e, t) ->
    Meteor.call 'removePendingCollab', @userId, t.data.photoBook._id, (error) ->
      if error
        FlashMessages.sendError 'could not remove pending collab, please contact support'
  'click #submitCollabUsername': (e, t) ->
    e.preventDefault()
    photoBookId = t.data.photoBook._id
    username = t.$('.collab-username').val()
    t.$('.collab-username').val('')
    console.log 'save clicked'
    Meteor.call 'addCollab', username, photoBookId, t.data.photoBook.name, (err) ->
      if err
        console.log err
      else
        console.log 'collab added'
  'click .removeCollab': (e, t) ->
     console.log 'remove clicked'
     self = @
     Meteor.call 'removeCollab', @userId, t.data.photoBook._id, (err) ->
      if err
        console.log err
      else
        if self.userId is Meteor.userId()
          $('.modal-backdrop').fadeOut 'fast', ->
            @remove()
        console.log 'collab removed'

Template.addCollabModal.helpers
  allowedToRemove: ->
    t = UI._templateInstance()
    Meteor.userId() is @userId or t.data.photoBook.userId is Meteor.userId()
  owner: ->
    t = UI._templateInstance()
    t.data.photoBook.userId is Meteor.userId()
  userOnline: ->

    userOnlineClassHelper @userId
  adminOnline: ->

    userOnlineClassHelper @photoBook.userId
  ownerUsername: ->
    #user = Meteor.users.findOne({_id: @researchThread.userId}, {fields: {username: 1, 'profile.firstName': 1, 'profile.lastName': 1}})
    user = Meteor.users.findOne({_id: @photoBook.userId}, {fields: {username: 1}})
    user.username
  ownerId: ->
    t = UI._templateInstance()
    t.data.photoBook.userId
  username: ->
    user = Meteor.users.findOne({_id: @userId})
    user.username
  settings: ->
    position: "top"
    limit: 5
    rules: [
      {
        collection: Meteor.users
        field: "username"
        template: Template.userPill
        filter: 
          _id:
            $not: Meteor.userId()
      }
    ]