Meteor.publish 'data', (query) ->
  return Data.find(query)
