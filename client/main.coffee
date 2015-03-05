Meteor.startup( ->
  Uploader.uploadUrl = Meteor.absoluteUrl "upload"  # Cordova needs absolute URL
)
