Template.pieChartControls.events
  "submit form": (e, t) -> 
  	e.preventDefault()
  	#
  	pieChartKey.set( t.find("[name=pie-chart-key]")?.value )
  	pieChartValue.set( t.find("[name=pie-chart-value]")?.value )
  	return false