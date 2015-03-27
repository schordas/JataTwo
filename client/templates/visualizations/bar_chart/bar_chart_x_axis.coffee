Template.barChartXAxis.helpers
	isSelected: (option)->
		if (barChartXAxis.get() == option) then true else false

Template.barChartXAxis.events
	"change select": (e,t)->
		barChartXAxis.set( t.find("[name=bar-chart-x-axis]")?.value )
		return
