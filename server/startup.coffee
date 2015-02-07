# Startup is slow because of data loading. Maybe some latency compensation
if Meteor.isServer
  # ReactiveTable.publish("query-items", Data, ->
  # {"Project Number" : "01STCR", "Task Number" : "R.12.023.024", "Fiscal Year" : "2013"})
  Meteor.startup ->
    #console.log(Data.find().count())
  return

if Meteor.isClient
  Meteor.subscribe 'data'
  Meteor.subscribe 'query-items'
  #console.log(Data.find().count())
