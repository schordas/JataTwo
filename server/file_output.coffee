Meteor.methods outputCSV: (query) ->
  data = Data.find(query)
  fs = Npm.require('fs')
  path = '../../../../../'
  outputString = ''
  # Columns
  outputString += 'Expenditure Type' + ',' + 'Fiscal Year' + ',' + 'Period Nbr' + ',' + 'Project Number' + ',' + 'Task Cognizant Org' + ',' + 'Task Number' + ',' + 'MTD Burdened Costs' + ',' + 'MTD Actual FTE' + ',' + 'MTD Hours' + ',' + 'MTD Burdened Obligations' + ',' + 'MTD Obligations' + ',' + 'MTD EAC BurdenedPlan' + ',' + 'MTD EAC Raw Plan' + ',' + 'MTD EOC Burdened Plan' + ',' + 'MTD EOC Raw Plan' + ',' + 'MTD EAC FTE Plan' + ',' + 'MTD EAC Hours Plan' + ',' + 'MTD Burdened Cost Plan' + ',' + 'MTD Burdened Oblg Plan' + ',' + 'MTD FTE Plan' + ',' + 'MTD Hours Plan' + ',' + 'MTD Raw Cost Plan' + ',' + 'MTD Raw Oblg Plan'
  outputString += '\n'
  data.forEach (item) ->
    for field of item
      if field.localeCompare('_id') != 0
        # skip the _id field
        outputString += item[field] + ','
    outputString += '\n'
    return
  fs.writeFile path + 'text.csv', outputString, (err) ->
    if err
      console.log err
    else
      console.log 'The file was saved!'
    return
  return