waitingForData = new ReactiveVar(false)

Template.jumbotronQuery.helpers
  waitingForData: ->
    waitingForData.get()

Template.jumbotronQuery.events
  "submit form": (e, t) ->
    #
    dataIsLoaded.set(false)
    waitingForData.set(true)
    e.preventDefault()
    #
    query = {}
    putFieldIntoQuery( t.find("[name=project]")?.value, "Project Number", query )
    putFieldIntoQuery( t.find("[name=taskNum]")?.value, "Task Number", query )
    putFieldIntoQuery( t.find("[name=fiscalYr]")?.value, "Fiscal Year", query )
    putFieldIntoQuery( t.find("[name=periodNbr]")?.value, "Period Nbr", query )
    #
    Session.set "query", query
    Meteor.subscribe('data', query, onReady: ->
      if Data.find().count() > 0
        dataIsLoaded.set(true) # Global var declared in global.coffee
      else
        bootbox.dialog({
          message: "Your parameters don't appear to be in the database. Check for spelling and case.",
          title: "Oops!",
          buttons: {
            success: {
              label: "OK",
              className: "btn-primary",
            },
          }
        });
      waitingForData.set(false)
      )
    createExportFiles(query)
    return false

putFieldIntoQuery = (value, fieldName, query)->
  if value
    if isRegex(value)
      regexFieldIntoQuery(value, fieldName, query)
    else if isCommaSeparated(value)
      commaSeparatedFieldIntoQuery(value, fieldName, query)
    else if isRanged(value)
      rangedFieldIntoQuery(value, fieldName, query)
    else # is normal, single value
      if !isNaN(value)
        value = Number(value)
      query[fieldName] = value
  return

# Regex - TODO. Not sure how to determine if regex yet...
isRegex = (value)->
  # try
  #   new RegExp(value, "i")
  #   return true
  # catch err
  #   return false
  return false

regexFieldIntoQuery = (value, fieldName, query)->
  query[fieldName] = { $regex: value }
  return

# Comma Separated
isCommaSeparated = (value)->
  value.split(',').length > 1

commaSeparatedFieldIntoQuery = (value, fieldName, query)->
  items = value.split(',')
  if items.length > 0
    itemsArray = []
    i = 0
    while i < items.length
      item = items[i].trim()
      if !isNaN item
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


#
Meteor.Spinner.options = {
  top: '220px',
  length: 30,
  width: 6
}
