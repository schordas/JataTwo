Template.table.helpers
  settings: ->
    console.log("Data " + Data.find().count())
    return {
    collection: Data.find(Session.get 'query'),
    rowsPerPage: 10,
    showFilter: true,
    fields: ["Fiscal Year","Period Nbr","Project Number","Task Number","MTD Actual FTE","MTD Burdened Obligations","MTD Obligations","MTD EAC BurdenedPlan","MTD EAC Raw Plan","MTD EOC Burdened Plan","MTD EOC Raw Plan","MTD EAC FTE Plan","MTD EAC Hours Plan","MTD Burdened Cost Plan","MTD Burdened Oblg Plan","MTD FTE Plan","MTD Hours Plan","MTD Raw Cost Plan","MTD Raw Oblg Plan"]};
