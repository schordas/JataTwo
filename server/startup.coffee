# Startup is slow because of data loading. Maybe some latency compensation
if Meteor.isServer
  Meteor.startup ->
    #console.log(Data.find().count())
  return

if Meteor.isClient
  Meteor.subscribe 'data'
  Meteor.subscribe 'query-items'
  #console.log(Data.find().count())
