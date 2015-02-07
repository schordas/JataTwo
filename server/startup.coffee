# Startup is slow because of data loading. Maybe some latency compensation
if Meteor.isServer
  ReactiveTable.publish("some-items", Data, {"show": true})
  Meteor.publish("")
  Meteor.startup ->
    #console.log(Data.find().count())
  return

if Meteor.isClient
  Meteor.subscribe 'data'
  Meteor.subscribe 'temp'
  #console.log(Data.find().count())
