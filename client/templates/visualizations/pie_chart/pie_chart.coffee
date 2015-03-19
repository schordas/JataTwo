#
# Global Vars
#
@pieChartKey = new ReactiveVar('Fiscal Year')
@pieChartValue = new ReactiveVar('MTD Burdened Costs')

Template.pieChart.rendered = ->
	Meteor.autorun ->
		if dataIsLoaded.get()
			#remove old pie chart, if exists
			if d3.select('#pie-chart-svg')[0][0] != null
				parent = document.getElementById('pie-chart')
				parent.removeChild(document.getElementById('pie-chart-svg'))

			# Data
			data = Data.find(Session.get 'query').fetch()
			aggregatedData = d3.nest().key((d)->
				d[pieChartKey.get()]
			).rollup((d)->
				{ 
				'value' : d3.sum(d, (e)->
					parseFloat e[pieChartValue.get()]
					)
				}
			).entries(data)
			sortedData = aggregatedData.sort((a,b)->
				d3.ascending pieLabel(a), pieLabel(b)
				)
			# Define chart parameters
			width = 960
			height = 500
			radius = Math.min(width, height) / 2
			color = d3.scale.ordinal().range([
				'#98abc5'
				'#8a89a6'
				'#7b6888'
				'#6b486b'
				'#a05d56'
				'#d0743c'
				'#ff8c00'
				])
			arc = d3.svg.arc().outerRadius(radius - 10).innerRadius(0)
			pie = d3.layout.pie().sort(null).value((d) ->
				d.values.value
				)
			# Create SVG
			svg = d3.select('#pie-chart').append('svg')
				.attr('id','pie-chart-svg')
				.attr('width', width)
				.attr('height', height)
				.append('g')
				.attr('transform', 'translate(' + (width / 2) + ',' + (height / 2) + ')')
			g = svg.selectAll('.arc').data(pie(sortedData)).enter().append('g').attr('class', 'arc')
			g.append('path').attr('d', arc).style 'fill', (d) ->
				color d.data.key
			g.append('text').attr('transform', (d) ->
				c = arc.centroid(d)
				'translate(' + c[0] + ',' + c[1] + ')'
			).attr('dy', '.35em').style('text-anchor', 'middle').text (d) ->
				d.data.key
		return # autorun
	return # rendered

pieLabel = (d) ->
    if isNaN d.key
      d.key
    else 
      Number(d.key)

