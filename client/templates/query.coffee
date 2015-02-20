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
    console.log(query)
    Meteor.subscribe('data', query)
    count = Data.find(query).count()
    console.log(count)
    Session.set "query", query
    #count = Data.find(query).count()
    #Still having latency issues
    Session.set "project", project
    Session.set "taskNum", taskNum
    Session.set "taskMan", taskMan
    return false
