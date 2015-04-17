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
					label: d;
				}
				)
		return years

Template.barChartXAxis.events
	"change select": (e)->
		if (e.target.name == "bar-chart-x-axis-year-control")
			barChartSelectedYear.set(e.target.value)
		else if (e.target.name == "bar-chart-x-axis")
			barChartXAxis.set( e.target.value )
		return
