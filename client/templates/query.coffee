Template.sidebarQuery.events
  "submit form": (e, t) ->
    e.preventDefault()
    project = t.find("[name=project]")?.value
    taskNum = t.find("[name=taskNum]")?.value
    taskMan = t.find("[name=taskMan]")?.value
    Session.set "project", project
    Session.set "taskNum", taskNum
    Session.set "taskMan", taskMan
    return false
