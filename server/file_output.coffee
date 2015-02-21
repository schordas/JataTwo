Meteor.methods outputCSV: (query) ->
  data = Data.find(query)
  fs = Npm.require('fs')
  path = '../../../../../'
  outputString = ''
  hasCols = false
  data.forEach (item) ->
    for field of item
      # Define Columns
      if !hasCols
        for field of item
          if field.localeCompare('_id') != 0
            outputString += field + ','
        outputString += '\n'
        hasCols = true
      # Rows
      if field.localeCompare('_id') != 0
        # skip the _id field
        outputString += item[field] + ','
    outputString += '\n'
    return
  fs.writeFile path + 'query.csv', outputString, (err) ->
    if err
      console.log err
    else
      console.log 'The file was saved!'
    return
  return