Template.jumbotronQuery.events
  "submit form": (e, t) ->
    e.preventDefault()
    project = t.find("[name=project]")?.value
    taskNum = t.find("[name=taskNum]")?.value
    taskMan = t.find("[name=taskMan]")?.value
    query = {}
    projectFinal = ""
    taskNumFinal = ""
    if project && taskNum
      query = {"Project Number" : project, "Task Number" : taskNum}
    else if project && !taskNum
      query = {"Project Number" : project}
    else if !project && taskNum
      query = {"Task Number" : taskNum}
    else
      console.log("Empty Query")
    Meteor.subscribe('data', query)
    Session.set "query", query
    #count = Data.find(query).count()
    #Still having latency issues
    Session.set "project", project
    Session.set "taskNum", taskNum
    Session.set "taskMan", taskMan
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