Template.barChartYAxis.helpers
	isSelected: (option)->
		if (barChartYAxis.get() == option) then true else false

Template.barChartYAxis.events
	"change select": (e,t)->
		barChartYAxis.set( t.find("[name=bar-chart-y-axis]")?.value )
		return
