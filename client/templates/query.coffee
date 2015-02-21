Template.sidebarQuery.events
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
    #console.log(query)
    Meteor.subscribe('data', query)
    Session.set "query", query
    #count = Data.find(query).count()
    #Still having latency issues
    Session.set "project", project
    Session.set "taskNum", taskNum
    Session.set "taskMan", taskMan
    return false
  'click button': ->
    console.log "click fired"
    query = Session.get 'query'
    console.log query
    bootbox.dialog
      message: "Select the file type you would like to export",
      buttons:
        json:
          label:"JSON",
          className:"btn-json",
          callback: ->
            console.log "Chose JSON"
            return
    if typeof query != 'undefined'
      Meteor.call 'outputCSV', query, (error) ->
        if error
          console.log 'Error'
        else
          console.log 'Everything good!'
        return
    else console.log 'nothing to export'
