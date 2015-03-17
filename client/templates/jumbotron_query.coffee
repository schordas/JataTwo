Template.jumbotronQuery.events
  "submit form": (e, t) ->
    dataIsLoaded.set(false)
    e.preventDefault()
    #
    query = {}
    putFieldIntoQuery( t.find("[name=project]")?.value, "Project Number", query )
    putFieldIntoQuery( t.find("[name=taskNum]")?.value, "Task Number", query )
    putFieldIntoQuery( t.find("[name=fiscalYr]")?.value, "Fiscal Year", query )
    putFieldIntoQuery( t.find("[name=periodNbr]")?.value, "Period Nbr", query )
    #
    console.log query
    Session.set "query", query
    Meteor.subscribe('data', query, onReady: ->
      dataIsLoaded.set(true) # Global var declared in global.coffee
      )
    createExportFiles(query)
    return false

putFieldIntoQuery = (value, fieldName, query)->
  if value
    if isCommaSeparated(value)
      commaSeparatedFieldIntoQuery(value, fieldName, query)
    else if isRanged(value)
      rangedFieldIntoQuery(value, fieldName, query)
    else # is normal, single value
      if !isNaN(value)
        value = Number(value)
      query[fieldName] = value
  return

# Comma Separated 
isCommaSeparated = (value)->
  value.split(',').length > 1

commaSeparatedFieldIntoQuery = (value, fieldName, query)->
  nums = value.match(/(\d+)/g)
  if nums
    items = nums
  else
    items = value.split(',')
  if items.length > 0
    itemsArray = []
    i = 0
    while i < items.length
      item = items[i].trim()
      if nums
        item = Number(item)
      itemsArray.push item
      ++i
  query[fieldName] = { $in: itemsArray } 
  return

# Range
isRanged = (value)->
  value.split('-').length == 2

rangedFieldIntoQuery = (value, fieldName, query)->
  nums = value.split('-')
  if nums.length == 2
    nums.sort()
    query[fieldName] = { $gte: Number(nums[0]), $lte: Number(nums[1]) } 
  return

# 
createExportFiles = (query)->
  fileId = moment().format()
  Session.set "fileId", fileId
  # output files
  if typeof query != 'undefined'
    Meteor.call 'createCSV', query, fileId, (error) ->
      if error
        console.log 'Error creating CSV file'
      return
    Meteor.call 'createJSON', query, fileId, (error) ->
      if error
        console.log 'Error creating JSON file'
      return
  return



