requireLogin = (pause) ->
  if !Meteor.user()
    @setLayout 'layoutLoggedOut'
    if Meteor.loggingIn()
      @render @loadingTemplate
    else
      @render 'login'
      pause()
  else
    @setLayout 'layout'

Router.configure 
  layoutTemplate: 'layout'
  loadingTemplate: 'loading'
  waitOn: ->
    if Meteor.userId()?
      [
        Meteor.subscribe 'myphotoBooks', Meteor.userId()
        #Meteor.subscribe "notifications", Meteor.userId()
        #Meteor.subscribe 'myCollections', Meteor.userId()
        #Meteor.subscribe 'allUsersUsernames'
      ]

#Do not require login for all public routes
Router.onBeforeAction requireLogin, 
  except: ['publicPage']

Router.onBeforeAction 'loading'

Router.onBeforeAction ->
  FlashMessages.clear()

Router.map ->
  @route 'login',
    path: '/',
    onBeforeAction: ->
      if Meteor.user()
        Router.go 'dashboard'
  @route 'dashboard',
    path: '/dashboard',
    # waitOn: ->
    #   Meteor.subscribe 'myphotoBooks', Meteor.userId()
    # data: ->
  @route 'photoBookPage',
    path: '/p/:_id',
    waitOn: ->
      PHOTOS_LIMIT = 30
      Session.set "photosLimit", PHOTOS_LIMIT
      [
        Meteor.subscribe 'photosForPhotoBook', @params._id, Meteor.userId(), PHOTOS_LIMIT,
          onError: ->
            path = encodeURIComponent(window.location.href)
            if Meteor.user()
              Router.go 'threadNotFound', {website: path}
      ]
    data: ->
      # this code is for appending the user data to fields pending and collaborators for this thread
      book = PhotoBooks.findOne({ $and: [{$or: [{userId: Meteor.userId()}, {'collaborators.userId': Meteor.userId()}] }, {_id: @params._id}] })
      return null unless book? and !book.trash?
      data = 
        photoBook: book

