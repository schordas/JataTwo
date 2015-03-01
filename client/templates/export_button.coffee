# Note: the files get created when the user queries. So, this functionality is implemented in query.coffee
Template.exportButton.helpers
  'CSVurl': ->
  	fileId = Session.get 'fileId'
  	if typeof fileId != 'undefined'
  		path = '/data/' + fileId + '/fileType/csv'
  	else 
  		path = ''
    return path
  'JSONurl': ->
  	fileId = Session.get 'fileId'
  	if typeof fileId != 'undefined'
  		path = '/data/' + fileId + '/fileType/json'
  	else 
  		path = ''
    return path

# Template.exportButton.events
#   'click #json-export': (e) ->
#     Meteor.call 'outputJSON', (error, id) ->
#       if error
#         Errors.throwError error.reason
#       false
#     false
#   'click #csv-export': (e) ->
#     Meteor.call 'outputCSV', (error, id) ->
#       if error
#         Errors.throwError error.reason
#       false
#     false