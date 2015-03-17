Template.barChart.rendered = ->
  Meteor.autorun ->
    if dataIsLoaded.get()
      queryData = Data.find().fetch()
      d3Data = []      
      widthSVG = 980
      heightSVG = 400
      widthBar = 15
      offsetBar = 3

      # initialize the array
      numTerms = 12 # this will need to be dynamic based on what the x-axis is chosen to be
      i = 0
      while i < numTerms
        d3Data[i] = 0 # init to zero
        i++

      # sum the data
      queryData.forEach (i)->
        d3Data[i['Period Nbr']] += i['MTD Burdened Costs']
        return

      # create ranges
      yScale = d3.scale.linear()
        .domain([0, d3.max(d3Data)])
        .range([0, heightSVG])

      xScale = d3.scale.ordinal()
        .domain(d3.range(0, numTerms))
        .rangeBands([0, widthSVG])
      
      # create bars
      d3.select('#bar-chart'). append('svg')
        .attr('width', widthSVG)
        .attr('height', heightSVG)
        .selectAll('rect').data(d3Data)
        .enter().append('rect')
          .style('fill', (d,i) ->
            if i % 2 == 0 # not working... I'm trying to alternate colors
              '#333'
            '#000'
            )
          .attr('width', xScale.rangeBand() )
          .attr('height', (d)->
            yScale(d)
            )
          .attr('x', (d, i) ->
            xScale(i)
            )
          .attr('y', (d) ->
            heightSVG - yScale(d)
            )
    # end dataIsLoaded
    return
  # end autorun POOP
  return 
