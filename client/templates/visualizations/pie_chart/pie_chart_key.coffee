Template.pieChartKey.helpers
	isSelected: (option)->
		if (pieChartKey.get() == option) then true else false

Template.pieChartKey.events
	"change select": (e,t)->
		pieChartKey.set( t.find("[name=pie-chart-key]")?.value )
		return