  Meteor.publish 'data', ->
    return Data.find()
