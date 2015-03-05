Meteor.methods
  createJSON: (query, fileId) ->
    dirPath = '../../../../../tmp/'
    filePath = dirPath + 'query_json_' + fileId + '.json' 
    data = Data.find(query).fetch()
    jsonData = JSON.stringify(data)
    fs = Npm.require('fs')
    fs.writeFile filePath, jsonData, (err) ->
      if err
        console.log err
      return
    return
  createCSV: (query, fileId) ->
    dirPath = '../../../../../tmp/'
    filePath = dirPath + 'query_csv_' + fileId + '.csv' 
    data = Data.find(query)
    fs = Npm.require('fs')
    outputString = ''
    # print columns
    item = Data.findOne()
    for col of item
      if col != '_id'
        outputString += col + ','
    outputString += '\n'
    # print out each row
    data.forEach (item) ->
      for field of item
        if field != '_id'
          if isNaN(item[field])
            outputString += '"' + item[field] + '",'
          else
            outputString += item[field] + ','
      # end for
      outputString += '\n'
      return
    fs.writeFile filePath, outputString, (err) ->
      if err
        console.log err
      return

#
# Output file to client
#
fs = Npm.require('fs')

fail = (response) ->
  response.statusCode = 404
  response.end()
  return

outputDataFile = ->
  # Create the file
  fileId = @params.fileId  
  fileType = @params.fileType
  fileName = 'query_' + fileType + '_' + fileId + '.' + fileType
  filePath = '../../../../../tmp/' + fileName
  # Attempt to read the file size
  stat = null
  try
    stat = fs.statSync(filePath)
  catch _error
    return fail(@response)
  # Set the headers
  @response.writeHead 200,
    'Content-Type': 'text/' + fileType
    'Content-Disposition': 'attachment; filename=' + fileName
    'Content-Length': stat.size
  # Pipe the file contents to the response
  fs.createReadStream(filePath).pipe @response
  return

Router.route '/data/:fileId/fileType/:fileType', outputDataFile, where: 'server'
