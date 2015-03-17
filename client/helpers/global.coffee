#
# dataIsLoaded is set to true when subscription .ready() is true
#						 false when a new query is made
#
@dataIsLoaded = new ReactiveVar(false)

Template.registerHelper 'dataIsLoaded', ->
	return dataIsLoaded.get()

#
# 
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
	console.log 'At home page...'
	return

