@Photos = new Mongo.Collection('photos')

Photos.allow
  update: ownsDocument
  remove: ownsDocument