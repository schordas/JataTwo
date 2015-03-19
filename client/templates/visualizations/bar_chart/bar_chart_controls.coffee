Template.barChartControls.events
  "submit form": (e, t) -> 
  	e.preventDefault()
  	#
  	barChartXAxis.set( t.find("[name=bar-chart-x-axis]")?.value )
  	barChartYAxis.set( t.find("[name=bar-chart-y-axis]")?.value )
  	return false