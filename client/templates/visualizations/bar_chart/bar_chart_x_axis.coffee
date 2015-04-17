Template.barChartXAxis.helpers
	isSelected: (option)->
		if (barChartXAxis.get() == option) then true else false
	isPeriodSelected: ->
		return (barChartXAxis.get() == "Period Nbr")
	years: ->
		years = []
		yearsInQuery.get().forEach (d)->
			years.push(
				{
					label: d
				}
				)
		return years

Template.barChartXAxis.events
	"change select": (e,t)->
		barChartXAxis.set( t.find("[name=bar-chart-x-axis]")?.value )
		return
