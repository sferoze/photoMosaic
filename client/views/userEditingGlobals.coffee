@userOnlineClassHelper = (userId) ->
  user = Meteor.users.findOne({_id: userId})
  if user.status?.invisible?
    if user.status.online and !user.status.invisible and userId isnt Meteor.userId()
      'online'
    else
      'offline'
  else if userId isnt Meteor.userId() and user.status?.online? and user.status.online
    'online'
  else
    'offline'