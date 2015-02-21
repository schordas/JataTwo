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
    Meteor.call 'outputCSV', query, (error) ->
      if error
        console.log 'Some shit went down'
      else
        console.log 'YAY! Beast mode ACTIVATED!!!!'
      return
    return false
  'click button': ->
    console.log("I have been clicked")
