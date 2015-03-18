Template.barChartControls.events
  "submit form": (e, t) -> 
  	e.preventDefault()
  	#
  	console.log t.find("[name=bar-chart-x-axis]")?.value
  	console.log t.find("[name=bar-chart-y-axis]")?.value
  	return false