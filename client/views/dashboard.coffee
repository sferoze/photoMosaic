# Add user Preference to set document

# 'click #preference': (e, t) ->
#   e?.preventDefault()
#   self = @
#   userId = Meteor.userId()
#   if t.pref?
#     Collection.update @document._id,
#       $pull: 
#         prefs: t.pref
#     , (error) ->
#       if !error

#         # Manipulate the preference here

#         Research.update self.document._id,
#           $addToSet:
#             prefs: t.pref
#   else
#     Collection.update @document._id,
#       $addToSet:
#         prefs:
#           userId: userId
#           field: true
Template.dashboard.helpers
  myphotoBooks: ->
    PhotoBooks.find()

Template.dashboard.events
  'click #addPhotoBook': (e, t) ->

    Meteor.call 'addPhotoBook', (err, photoBookId) ->
      photoBookDoc = PhotoBooks.findOne({_id: photoBookId})
      template = Blaze.renderWithData Template.photoBookSettingsModal, photoBookDoc, document.body
      $(template.firstNode()).modal 'show'

      Meteor.defer ->
        t.$('#photoBooksGrid').masonry('reloadItems')
        t.$('#photoBooksGrid').masonry()

      $(template.firstNode()).one 'hidden.bs.modal', (e) ->
        Blaze.remove template

  'click .open-settings': (e, t) ->
    e.preventDefault()
    template = Blaze.renderWithData Template.photoBookSettingsModal, @, document.body
    $(template.firstNode()).modal 'show'

    $(template.firstNode()).one 'hidden.bs.modal', (e) ->
      Blaze.remove template


Template.dashboard.rendered = ->
  console.log 'rendered'

  $container = @$('#photoBooksGrid')
  $container.masonry
    #columnWidth: 130,
    itemSelector: '.photo-book-item',
    gutterWidth: 0,
    isResizable: true

  # @prefComputation = Deps.autorun ->
  #   thread = Collection.findOne({_id: self.data.collection._id}, {fields: {collaborators: 1, prefs: 1, userId: 1}})
  #   Session.set 'currentDocument', thread
  #   # self.hasCollaborators is used in insert note and node note
  #   if thread?.collaborators?.length > 0
  #     self.hasCollaborators = true
  #   else
  #     self.hasCollaborators = false

  #   if thread?.prefs?.length > 0
  #     _.each thread.prefs, (pref) ->
  #       if pref.userId is Meteor.userId()
  #         self.pref = pref
  #         Session.set 'usersDocumentPreference', pref