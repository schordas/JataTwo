Template.jumbotronQuery.events
  "submit form": (e, t) ->
    dataIsLoaded.set(false)
    e.preventDefault()
    project = t.find("[name=project]")?.value
    taskNum = t.find("[name=taskNum]")?.value
    fiscalYr = t.find("[name=fiscalYr]")?.value
    periodNbr = t.find("[name=periodNbr]")?.value
    query = {}
    if project
      query["Project Number"] = project
    if taskNum
      query["Task Number"] = taskNum
    if fiscalYr
      regexNbr = /(\d+)/g
      regexHyphen = /-/
      nums = fiscalYr.match(regexNbr)
      if nums.length > 1
        nums.sort()
        if fiscalYr.match(regexHyphen) # it's a range
          query["Fiscal Year"] = {$gte: Number(nums[0]), $lte: Number(nums[1])}
      else if nums.length == 1
        query["Fiscal Year"] = Number(nums[0])
    if periodNbr
      regexNbr = /(\d+)/g
      regexHyphen = /-/
      nums = periodNbr.match(regexNbr)
      if nums.length > 1
        nums.sort()
        if periodNbr.match(regexHyphen) # it's a range
          query["Period Nbr"] = {$gte: Number(nums[0]), $lte: Number(nums[1])} 
      else if nums.length == 1
        query["Period Nbr"] = Number(nums[0])
    Meteor.subscribe('data', query, onReady: ->
      dataIsLoaded.set(true) # Global var declared in global.coffee
      )
    Session.set "query", query
    # Still having latency issues
    Session.set "project", project
    Session.set "taskNum", taskNum
    #
    # Create the export files on query
    #
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
    return false

