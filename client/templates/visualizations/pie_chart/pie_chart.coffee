#
# Global Vars
#
@pieChartKey = new ReactiveVar('Fiscal Year')
@pieChartValue = new ReactiveVar('MTD Burdened Costs')

Template.pieChart.rendered = ->
	Meteor.autorun ->
    	if dataIsLoaded.get()
    		# remove old pie chart, if exists
      		if d3.select('#pie-chart-svg')[0][0] != null
        		parent = document.getElementById('pie-chart')
        		parent.removeChild(document.getElementById('pie-chart-svg'))
        	#

    	return # autorun
    return # rendered


