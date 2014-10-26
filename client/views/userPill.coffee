Template.userPill.helpers
  'status': ->
    user = Meteor.users.findOne({_id: @_id})
    if user.status?.invisible?
      if user.status.online and !user.status.invisible and userId isnt Meteor.userId()
        'online'
      else
        'offline'
    else if user.status?.online? and user.status.online
      'online'
    else
      'offline'
