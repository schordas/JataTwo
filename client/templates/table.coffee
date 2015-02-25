Template.table.helpers
  project: ->
    project = Session.get 'project'
    return project

  taskNum: ->
    taskNum = Session.get 'taskNum'
    return taskNum

  taskMan: ->
    taskMan = Session.get 'taskMan'
    return taskMan
