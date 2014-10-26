Template.photoBookPage.helpers
  capturedImage: ->
    Photos.find({photoBookId: @photoBook._id})

#onSuccess = (err, imageData) ->
  # image = new Image()
  # image.src = imageData
  # $("body").append image

  # imageData = imageData.split(',', 2)[1]
  # position = Geolocation.latLng()

  # console.log imageData
  # filepicker.store imageData,
  #   filename: "testPhotoBook.jpeg"
  #   base64decode: true
  #   mimetype: 'image/jpeg'
  # , (new_blob) ->
  #   console.log JSON.stringify(new_blob)
  #   Meteor.call 'saveImage', new_blob, position,  Meteor.userId()
  # , (FPError) ->
  #   console.log FPError
  # , (percent) ->
  #   num = percent/100
  #   NProgress.set(num)

  # Meteor.defer ->
  #   setTimeout ->
  #     $('#photoGrid').masonry('reloadItems')
  #     $('#photoGrid').masonry()
  #   , 0 

Template.photoBookPage.events
  'click #logPosition': (e) ->
    position = Geolocation.latLng()
    console.log position
  'click #takePicture': (e, t) ->
    self = @
    #filepicker.setKey('AwkZBAT1mTTe20Bb0qOF9z')

    MeteorCamera.getPicture 
      quality: 80
    , (err, imageData) ->

        imageData = imageData.split(',', 2)[1]
        position = Geolocation.latLng()

        filepicker.store imageData,
          filename: "testPhotoBook.jpeg"
          base64decode: true
          mimetype: 'image/jpeg'
        , (new_blob) ->
          console.log JSON.stringify(new_blob)
          Meteor.call 'savePhoto', new_blob, position, Meteor.userId(), self.photoBook._id
        , (FPError) ->
          console.log FPError
        , (percent) ->
          num = percent/100
          NProgress.set(num)

  # 'click .item': (e) ->
  #   console.log @blob
  #   filepicker.remove @blob, =>
  #     console.log "Removed"
  #     Images.remove @_id

Template.photoBookPage.rendered = ->
  self = @
  filepicker.setKey('AwkZBAT1mTTe20Bb0qOF9z')

  Meteor.defer ->

    imagesLoaded '#photoGrid', ->

      $container = $('#photoGrid')

      $container.masonry
        #columnWidth: columnWidth,
        itemSelector: '.item',
        gutterWidth: 0,
        isResizable: true



    $('#photoGrid').addClass 'ready'

    #filepickerWidget = self.find('#filepicker-dragdrop')
    #filepicker.constructWidget(filepickerWidget)

    # myLatlng = new google.maps.LatLng(-25.363882, 131.044922)
    # mapOptions =
    #   zoom: 4
    #   center: myLatlng

    # map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions)


  #Hammer.plugins.showTouches()  if not Hammer.HAS_TOUCHEVENTS and not Hammer.HAS_POINTEREVENTS
  #Hammer.plugins.fakeMultitouch()  if not Hammer.HAS_TOUCHEVENTS and not Hammer.HAS_POINTEREVENTS
  

  # hammertime = Hammer(document.getElementById("photoGridWrapper"),
  #   transform_always_block: true
  #   transform_min_scale: 1
  #   drag_block_horizontal: true
  #   drag_block_vertical: true
  #   drag_min_distance: 0
  # )

  # posX = 0
  # posY = 0
  # lastPosX = 0
  # lastPosY = 0
  # bufferX = 0
  # bufferY = 0
  # scale = 1
  # last_scale = undefined
  # rotation = 1
  # last_rotation = undefined
  # dragReady = 0

  # manageMultitouch = (ev, elemRect) ->
  #   switch ev.type
  #     when "touch"
  #       last_scale = scale
  #       last_rotation = rotation
  #     when "drag"
  #       posX = ev.gesture.deltaX + lastPosX
  #       posY = ev.gesture.deltaY + lastPosY
  #     when "transform"
  #       rotation = last_rotation + ev.gesture.rotation
  #       scale = Math.max(1, Math.min(last_scale * ev.gesture.scale, 10))
  #       console.log 'transformed'
  #       console.log scale
  #     when "dragend"
  #       lastPosX = posX
  #       lastPosY = posY
  #   transform = "translate3d(" + posX + "px," + posY + "px, 0)" + "scale3d(" + scale + "," + scale + ", 0)"
  #   elemRect.style.transform = transform
  #   elemRect.style.oTransform = transform
  #   elemRect.style.msTransform = transform
  #   elemRect.style.mozTransform = transform
  #   elemRect.style.webkitTransform = transform
  #   return


  
  # hammertime.on "touch drag dragend transform", (ev) ->
  #   elemRect = document.getElementById("photoGrid")
  #   manageMultitouch ev, elemRect


Template.photoItem.helpers
  mobile: ->
    if Meteor.isCordova
      'mobile'
    else
      ''

Template.photoItem.rendered = ->
  if $('#photoGrid').hasClass 'ready'
    Meteor.defer ->
      setTimeout ->
        $('#photoGrid').masonry('reloadItems')
        $('#photoGrid').masonry()
      , 0 