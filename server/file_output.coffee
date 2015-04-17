Meteor.methods
  createJSON: (query, fileId) ->
    # make sure folder exists
    fs = Npm.require('fs')
    dirPath = '../../../../../tmp/'
    fs.exists dirPath, (exists) ->
      if !exists
        fs.mkdirSync dirPath
      return
    #
    filePath = dirPath + 'query_json_' + fileId + '.json' 
    data = Data.find(query)
    # print out each row
    outputString = '[\n'
    data.forEach (item) ->
      outputString += '\t{\n'      
      for field of item
        if field != '_id'
          outputString += '\t\t"' + field + '" : '
          if isNaN(item[field])
            outputString += '"' + item[field] + '"'
          else
            outputString += item[field]
          outputString += ',\n'
      outputString += '\t},\n'
      return
    outputString += ']'
    fs.writeFile filePath, outputString, (err) ->
      if err
        console.log err
      return
    return
  createCSV: (query, fileId) ->
    # make sure folder exists
    fs = Npm.require('fs')
    dirPath = '../../../../../tmp/'
    fs.exists dirPath, (exists) ->
      if !exists
        fs.mkdirSync dirPath
      return
    #
    filePath = dirPath + 'query_csv_' + fileId + '.csv' 
    data = Data.find(query)
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
