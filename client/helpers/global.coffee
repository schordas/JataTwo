#
# dataIsLoaded is set to true when subscription .ready() is true
#						 false when a new query is made
#
@dataIsLoaded = new ReactiveVar(false)

Template.registerHelper 'dataIsLoaded', ->
	return dataIsLoaded.get()

# Defines the possible domains for graphs
Template.registerHelper 'domain', ->
	return [
			{label: "Fiscal Year"},
			{label: "Period Nbr"},
			{label: "Project Number"},
			{label: "Task Cognizant Org"}
		] 

# Defines the possible range for graphs
Template.registerHelper 'range', ->
	return [
			{label: "MTD Burdened Costs"},
			{label: "MTD Actual FTE"},
			{label: "MTD Hours"},
			{label: "MTD Burdened Obligations"},
			{label: "MTD Obligations"},
			{label: "MTD EAC BurdenedPlan"},
			{label: "MTD EAC Raw Plan"},
			{label: "MTD EOC Burdened Plan"},
			{label: "MTD EOC Raw Plan"},
			{label: "MTD Burdened Cost Plan"},
			{label: "MTD Burdened Oblg Plan"},
			{label: "MTD FTE Plan"},
			{label: "MTD Hours Plan"},
			{label: "MTD Raw Cost Plan"},
			{label: "MTD Raw Oblg Plan"}
		]
Template.registerHelper 'drillDownValues', ->
    return [
      	{
        	label: 'Level 1',
        	value: 'level1'
      	}, 
      	{
        	label: 'Level 2',
        	value: 'level2'
      	}
    	]

Template.registerHelper 'withIndex', (list) ->
    withIndex = _.map list, (v, i) ->
        v.index = i
        return v
    return withIndex

#
# All data fields in array format
#
@fields = [
	"Fiscal Year",
	"Period Nbr",
	"Project Number",
	"Task Number",
	"MTD Actual FTE",
	"MTD Burdened Obligations",
	"MTD Obligations",
	"MTD EAC BurdenedPlan",
	"MTD EAC Raw Plan",
	"MTD EOC Burdened Plan",
	"MTD EOC Raw Plan",
	"MTD EAC FTE Plan",
	"MTD EAC Hours Plan",
	"MTD Burdened Cost Plan",
	"MTD Burdened Oblg Plan",
	"MTD FTE Plan",
	"MTD Hours Plan",
	"MTD Raw Cost Plan",
	"MTD Raw Oblg Plan"
]

# Cheap fix to get rid of Iron Router splash on homepage. TODO remove later on...
Router.route '/', ->
	return

