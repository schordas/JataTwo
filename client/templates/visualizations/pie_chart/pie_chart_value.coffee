Template.pieChartValue.helpers
	isSelected: (option)->
		if (pieChartValue.get() == option) then true else false

Template.pieChartValue.events
	"change select": (e,t)->
		pieChartValue.set( t.find("[name=pie-chart-value]")?.value )
		return