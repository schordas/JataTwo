Template.exportButton.events
  'click #json-export': (e) ->
    Meteor.call 'outputJSON', (error, id) ->
      if error
        Errors.throwError error.reason
      false
    false
  'click #csv-export': (e) ->
    Meteor.call 'outputCSV', (error, id) ->
      if error
        Errors.throwError error.reason
      false
    false