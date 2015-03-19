#
# Global vars
#
@barChartXAxis = new ReactiveVar('Fiscal Year')
@barChartYAxis = new ReactiveVar('MTD Burdened Costs')

Template.barChart.rendered = ->
  Meteor.autorun ->
    if dataIsLoaded.get()
      if d3.select('#bar-chart-svg')[0][0] != null
        parent = document.getElementById('bar-chart')
        parent.removeChild(document.getElementById('bar-chart-svg'))
      valueLabelWidth = 60
      # space reserved for value labels (right)
      barHeight = 20
      # height of one bar
      barLabelWidth = 170
      # space reserved for bar labels
      barLabelPadding = 5
      # padding between bar and bar labels (left)
      gridLabelHeight = 18
      # space reserved for gridline labels
      gridChartOffset = 3
      # space between start of grid and first bar
      maxBarWidth = 900
      # width of the bar with the max value
      color = '#ce1126'
      # data aggregation
      aggregatedData = d3.nest().key((d) ->
        d[barChartXAxis.get()]
      ).rollup((d) ->
        { 'value': d3.sum(d, (e) ->
          parseFloat e[barChartYAxis.get()]
        ) }
      ).entries(Data.find(Session.get 'query').fetch())
      # accessor functions 

      barLabel = (d) ->
        d.key

      barValue = (d) ->
        d.values.value

      # sorting
      sortedData = aggregatedData.sort((a, b) ->
        d3.ascending barLabel(a), barLabel(b)
      )
      # scales
      yScale = d3.scale.ordinal().domain(d3.range(0, sortedData.length)).rangeBands([
        0
        sortedData.length * barHeight
      ])

      y = (d, i) ->
        yScale i

      yText = (d, i) ->
        y(d, i) + yScale.rangeBand() / 2

      x = d3.scale.linear().domain([
        0
        d3.max(sortedData, barValue)
      ]).range([
        0
        maxBarWidth
      ])

      # svg container element
      chart = d3.select('#bar-chart').append('svg').attr('id','bar-chart-svg').attr('width', (maxBarWidth + barLabelWidth + valueLabelWidth)).attr('height', gridLabelHeight + gridChartOffset + sortedData.length * barHeight)
      # axes labels
      xAxisLabel = chart.append('text').attr('x',10).attr('y',10).text barChartXAxis.get()
      yAxisLabel = chart.append('text').attr('x',maxBarWidth/2).attr('y',10).text barChartYAxis. get()
      # grid line labels
      gridContainer = chart.append('g').attr('transform', 'translate(' + barLabelWidth + ',' + gridLabelHeight + ')')
      gridContainer.selectAll('text').data(x.ticks(10)).enter().append('text').attr('x', x).attr('dy', -3).attr('text-anchor', 'middle').text String
      # vertical grid lines
      gridContainer.selectAll('line').data(x.ticks(10)).enter().append('line').attr('x1', x).attr('x2', x).attr('y1', 0).attr('y2', yScale.rangeExtent()[1] + gridChartOffset).style 'stroke', '#ccc'
      # bar labels
      labelsContainer = chart.append('g').attr('transform', 'translate(' + (barLabelWidth - barLabelPadding) + ',' + (gridLabelHeight + gridChartOffset) + ')')
      labelsContainer.selectAll('text').data(sortedData).enter().append('text').attr('y', yText).attr('stroke', 'none').attr('fill', 'black').attr('dy', '.35em').attr('text-anchor', 'end').text barLabel
      # bars
      barsContainer = chart.append('g').attr('transform', 'translate(' + barLabelWidth + ',' + (gridLabelHeight + gridChartOffset) + ')')
      barsContainer.selectAll('rect').data(sortedData).enter().append('rect').attr('y', y).attr('height', yScale.rangeBand()).attr('width', (d) ->
        x barValue(d)
      ).attr('stroke', 'white').attr 'fill', color
      # bar value labels
      barsContainer.selectAll('text').data(sortedData).enter().append('text').attr('x', (d) ->
        x barValue(d)
      ).attr('y', yText).attr('dx', 3).attr('dy', '.35em').attr('text-anchor', 'start').attr('fill', 'black').attr('stroke', 'none').text (d) ->
        d3.round barValue(d), 2
      # start line
      barsContainer.append('line').attr('y1', -gridChartOffset).attr('y2', yScale.rangeExtent()[1] + gridChartOffset).style 'stroke', '#000'
    # end dataIsLoaded
    return
  # end autorun
  return 
