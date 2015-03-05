Template.page.helpers
  morgan: ->
    m = false
    if Meteor.user() != null and Meteor.user() != undefined
      if Meteor.user().username == 'morgan'
        m = true
    return m
