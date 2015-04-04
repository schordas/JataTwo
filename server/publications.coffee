Meteor.publish 'data', (query) ->
  return Data.find(query)

Meteor.publish 'dataHierarchy', ->
  return DataHierarchy.find({})
