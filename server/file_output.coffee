Meteor.methods
  createJSON: (query, fileId) ->
    dirPath = '../../../../../tmp/'
    filePath = dirPath + 'query_json_' + fileId + '.json' 
    data = Data.find(query).fetch()
    jsonData = JSON.stringify(data)
    fs = Npm.require('fs')
    fs.writeFile filePath, jsonData, (err) ->
      console.log 'done writing file...'
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
    hasCols = false
    data.forEach (item) ->
      field = undefined
      for field of item
        `field = field`
        if !hasCols
          for field of item
            `field = field`
            if `field.localeCompare('_id') != 0`
              outputString += field + ','
          outputString += '\n'
          hasCols = true
        if `field.localeCompare('_id') != 0`
          outputString += item[field] + ','
      outputString += '\n'
      return
    fs.writeFile filePath, outputString, (err) ->
      if err
        console.log err
      return
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
  fileType = @params.fileType
  path = '../../../../../tmp/'
  timeStamp = moment().format()
  fileName = 'data_' + fileType + '_' + timeStamp + '.' + fileType
  filePath = path + fileName
  # 
  Meteor.wrapAsync(Meteor.call 'createJSON')
  console.log 'Moving along'

  # export the file
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

  # delete the file
  




  # fileId = @params.fileId  
  # fileType = @params.fileType
  # fileName = 'query_' + fileType + '_' + fileId + '.' + fileType
  # filePath = '../../../../../tmp/' + fileName
  # # Attempt to read the file size
  # stat = null
  # try
  #   stat = fs.statSync(filePath)
  # catch _error
  #   return fail(@response)
  # # Set the headers
  # @response.writeHead 200,
  #   'Content-Type': 'text/' + fileType
  #   'Content-Disposition': 'attachment; filename=' + fileName
  #   'Content-Length': stat.size
  # # Pipe the file contents to the response
  # fs.createReadStream(filePath).pipe @response
  return

Router.route '/data/:fileId/fileType/:fileType', outputDataFile, where: 'server'
