Meteor.methods
  outputJSON: (query) ->
    console.log 'hmm'
    return
  outputCSV: (query) ->
    data = Data.find(query)
    fs = Npm.require('fs')
    path = '../../../../../'
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
    fs.writeFile path + 'query.csv', outputString, (err) ->
      if err
        console.log err
      else
        console.log 'The file was saved!'
      return
    return