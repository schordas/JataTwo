Template.table.helpers
  settings: ->
    return {
      collection: Temp,
    rowsPerPage: 10,
    showFilter: true,
    fields: ["Fiscal Year","Period Nbr","Project Number","Task Number","MTD Actual FTW","MTD Burdened Obligations","MTD Obligations","MTD EAC BurdenedPlan","MTD EAC Raw Plan","MTD EOC Burdened Plan","MTD EOC Raw Plan","MTD EAC FTE Plan","MTD EAC Hours Plan","MTD Burdened Cost Plan","MTD Burdened Oblg Plan","MTD FTE Plan","MTD Hours Plan","MTD Raw Cost Plan","MTD Raw Oblg Plan"]};
  # project: ->
  #   project = Session.get 'project'
  #   return project
  #
  # taskNum: ->
  #   taskNum = Session.get 'taskNum'
  #   return taskNum
  #
  # taskMan: ->
  #   taskMan = Session.get 'taskMan'
  #   return taskMan
