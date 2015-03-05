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