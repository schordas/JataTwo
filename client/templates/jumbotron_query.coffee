Template.jumbotronQuery.events
  "submit form": (e, t) ->
    dataIsLoaded.set(false)
    e.preventDefault()
    #
    query = {}
    putFieldIntoQuery( t.find("[name=project]")?.value, "Project Number", query)
    putFieldIntoQuery( t.find("[name=taskNum]")?.value, "Task Number", query)
    putFieldIntoQuery( t.find("[name=fiscalYr]")?.value, "Fiscal Year", query)
    putFieldIntoQuery( t.find("[name=periodNbr]")?.value, "Period Nbr", query)
    #
    console.log query
    Session.set "query", query
    Meteor.subscribe('data', query, onReady: ->
      dataIsLoaded.set(true) # Global var declared in global.coffee
      )
    createExportFiles(query)
    return false

putFieldIntoQuery = (field, fieldName, query)->
  if field
    if isCommaSeparated(field)
      commaSeparatedFieldIntoQuery(field, fieldName, query)
    else if isRanged(field)
      rangedFieldIntoQuery(field, fieldName, query)
    else # is normal, single field
      if !isNaN(field)
        field = Number(field)
      query[fieldName] = field
  return

isCommaSeparated = (field)->
  field.split(',').length > 1

commaSeparatedFieldIntoQuery = (field, fieldName, query)->
  nums = field.match(/(\d+)/g)
  if nums
    items = nums
    console.log 'number'
  else
    items = field.split(',')
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

isRanged = (field)->
  field.split('-').length == 2

rangedFieldIntoQuery = (field, fieldName, query)->
  nums = field.split('-')
  if nums.length == 2
    nums.sort()
    query[fieldName] = { $gte: Number(nums[0]), $lte: Number(nums[1]) } 
  return

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



