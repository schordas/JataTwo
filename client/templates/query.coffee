Template.sidebarQuery.events
  "submit form": (e, t) ->
    e.preventDefault()
    project = t.find("[name=project]")?.value
    taskNum = t.find("[name=taskNum]")?.value
    taskMan = t.find("[name=taskMan]")?.value
    Meteor.subscribe 'data'
    query = {"Project Number" : project, "Task Number" : taskNum}
    Session.set "query", query
    count = Data.find(query).count()
    console.log(count)
    #Still having latency issues
    Session.set "project", project
    Session.set "taskNum", taskNum
    Session.set "taskMan", taskMan
    return false
