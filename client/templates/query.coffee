Template.sidebarQuery.events
  "submit form": (e, t) ->
    e.preventDefault()
    project = t.find("[name=project]")?.value
    taskNum = t.find("[name=taskNum]")?.value
    taskMan = t.find("[name=taskMan]")?.value
    Meteor.subscribe 'data'
    query = {"Project Number" : project, "Task Number" : taskNum} #, "MTD Raw Oblg Plan" : "9687"}
    Session.set "query", query
    count = Data.find(query).count()
    console.log(count)
    # Not sure this is the right way to do this.
    # Reactive tables take in a collection which makes things easy so if
    # make this work it would be nice.
    # Right now only works for single return from query. Tried for loop, didn't
    # work.
    # Also we need to either delete or reset the db
    # before every query.
    #Temp.insert(Data.find(query).fetch()[0]) # This only works for single return
    Session.set "project", project
    Session.set "taskNum", taskNum
    Session.set "taskMan", taskMan
    return false
