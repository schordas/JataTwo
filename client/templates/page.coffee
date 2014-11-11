Template.page.helpers
  showTable: ->
    return Session.get('project') or Session.get('taskNum') or Session.get('taskMan')
