barChartXAxis = new ReactiveVar('Fiscal Year');

barChartYAxis = new ReactiveVar('MTD Burdened Costs');

Template.barChart.rendered = function() {
  Meteor.autorun(function() {
    var barChartContainer;
    if (dataIsLoaded.get()) {
      if (d3.select('#bar-chart-svg')[0][0] !== null) {
        barChartContainer = document.getElementById('bar-chart');
        barChartContainer.removeChild(document.getElementById('bar-chart-svg'));
      }
      renderBarChart();
    }
  });
};

function renderBarChart() {
  /*
  * Data Aggregation
  */
  var aggregatedData = d3.nest().key(function(d) {
    return d[barChartXAxis.get()];
  }).rollup(function(d) {
    return {
      'value': d3.sum(d, function(e) {
        return parseFloat(e[barChartYAxis.get()]);
      })
    };
  }).entries(Data.find(Session.get('query')).fetch());

  var sortedData = aggregatedData.sort(function(a, b) {
    return d3.ascending(barLabel(a), barLabel(b));
  });

  /*
  * Bar Chart
  */
  // Declare variables
  var w = 960,
    h = 500,
    p = [20, 50, 30, 20],
    x = d3.scale.ordinal().rangeRoundBands([0, w - p[1] - p[3]]),
    y = d3.scale.linear().range([0, h - p[0] - p[2]]),
    z = d3.scale.ordinal().range(["lightpink", "darkgray", "lightblue"]),
    parse = d3.time.format("%m/%Y").parse,
    format = d3.time.format("%b");

  var svg = d3.select("#bar-chart").append("svg:svg")
      .attr("width", w)
      .attr("height", h)
      .attr("id", "#bar-chart-svg")
    .append("svg:g")
      .attr("transform", "translate(" + p[3] + "," + (h - p[2]) + ")");

  // Transpose the data into layers by cause.
  var causes = d3.layout.stack()(["wounds", "other", "disease"].map(function(cause) {
    return crimea.map(function(d) {
      return {x: parse(d.date), y: +d[cause]};
    });
  }));

  // Compute the x-domain (by date) and y-domain (by top).
  x.domain(causes[0].map(function(d) { return d.x; }));
  y.domain([0, d3.max(causes[causes.length - 1], function(d) { return d.y0 + d.y; })]);

  // Add a group for each cause.
  var cause = svg.selectAll("g.cause")
      .data(causes)
    .enter().append("svg:g")
      .attr("class", "cause")
      .style("fill", function(d, i) { return z(i); })
      .style("stroke", function(d, i) { return d3.rgb(z(i)).darker(); });

  // Add a rect for each date.
  var rect = cause.selectAll("rect")
      .data(Object)
    .enter().append("svg:rect")
      .attr("x", function(d) { return x(d.x); })
      .attr("y", function(d) { return -y(d.y0) - y(d.y); })
      .attr("height", function(d) { return y(d.y); })
      .attr("width", x.rangeBand());

  // Add a label per date.
  var label = svg.selectAll("text")
      .data(x.domain())
    .enter().append("svg:text")
      .attr("x", function(d) { return x(d) + x.rangeBand() / 2; })
      .attr("y", 6)
      .attr("text-anchor", "middle")
      .attr("dy", ".71em")
      .text(format);

  // Add y-axis rules.
  var rule = svg.selectAll("g.rule")
      .data(y.ticks(5))
    .enter().append("svg:g")
      .attr("class", "rule")
      .attr("transform", function(d) { return "translate(0," + -y(d) + ")"; });

  rule.append("svg:line")
      .attr("x2", w - p[1] - p[3])
      .style("stroke", function(d) { return d ? "#fff" : "#000"; })
      .style("stroke-opacity", function(d) { return d ? .7 : null; });

  rule.append("svg:text")
      .attr("x", w - p[1] - p[3] + 6)
      .attr("dy", ".35em")
      .text(d3.format(",d"));



  // var valueLabelWidth = 60;
  // var barHeight = 20;
  // var barLabelWidth = barChartXAxis.get().length * 4;
  // var barLabelPadding = 5;
  // var gridLabelHeight = 18;
  // var gridChartOffset = 3;
  // var maxBarWidth = 900;
  // var color = '#ce1126';
  // var barLabel = function(d) {
  //   if (isNaN(d.key)) {
  //     return d.key;
  //   } else {
  //     return Number(d.key);
  //   }-
  // };
  // var barValue = function(d) {
  //   return d.values.value;
  // };
  // var aggregatedData = d3.nest().key(function(d) {
  //   return d[barChartXAxis.get()];
  // }).rollup(function(d) {
  //   return {
  //     'value': d3.sum(d, function(e) {
  //       return parseFloat(e[barChartYAxis.get()]);
  //     })
  //   };
  // }).entries(Data.find(Session.get('query')).fetch());
  // var sortedData = aggregatedData.sort(function(a, b) {
  //   return d3.ascending(barLabel(a), barLabel(b));
  // });
  // var yScale = d3.scale.ordinal().domain(d3.range(0, sortedData.length)).rangeBands([0, sortedData.length * barHeight]);
  // var y = function(d, i) {
  //   return yScale(i);
  // };
  // var yText = function(d, i) {
  //   return y(d, i) + yScale.rangeBand() / 2;
  // };
  // var x = d3.scale.linear().domain([0, d3.max(sortedData, barValue)]).range([0, maxBarWidth]);
  // var chart = d3.select('#bar-chart').append('svg').attr('id', 'bar-chart-svg').attr('width', maxBarWidth + barLabelWidth + valueLabelWidth).attr('height', gridLabelHeight + gridChartOffset + sortedData.length * barHeight);
  // var xAxisLabel = chart.append('text').attr('x', 10).attr('y', 10).text(barChartXAxis.get());
  // var yAxisLabel = chart.append('text').attr('x', maxBarWidth / 2).attr('y', 10).text(barChartYAxis.get());
  // var gridContainer = chart.append('g').attr('transform', 'translate(' + barLabelWidth + ',' + gridLabelHeight + ')');
  // gridContainer.selectAll('text').data(x.ticks(10)).enter().append('text').attr('x', x).attr('dy', -3).attr('text-anchor', 'middle').text(String);
  // gridContainer.selectAll('line').data(x.ticks(10)).enter().append('line').attr('x1', x).attr('x2', x).attr('y1', 0).attr('y2', yScale.rangeExtent()[1] + gridChartOffset).style('stroke', '#ccc');
  // var labelsContainer = chart.append('g').attr('transform', 'translate(' + (barLabelWidth - barLabelPadding) + ',' + (gridLabelHeight + gridChartOffset) + ')');
  // labelsContainer.selectAll('text').data(sortedData).enter().append('text').attr('y', yText).attr('stroke', 'none').attr('fill', 'black').attr('dy', '.35em').attr('text-anchor', 'end').text(barLabel);
  // var barsContainer = chart.append('g').attr('transform', 'translate(' + barLabelWidth + ',' + (gridLabelHeight + gridChartOffset) + ')');
  // barsContainer.selectAll('rect').data(sortedData).enter().append('rect').attr('y', y).attr('height', yScale.rangeBand()).attr('width', function(d) {
  //   return x(barValue(d));
  // }).attr('stroke', 'white').attr('fill', color);
  // barsContainer.selectAll('text').data(sortedData).enter().append('text').attr('x', function(d) {
  //   return x(barValue(d));
  // }).attr('y', yText).attr('dx', 3).attr('dy', '.35em').attr('text-anchor', 'start').attr('fill', 'black').attr('stroke', 'none').text(function(d) {
  //   return d3.round(barValue(d), 2);
  // });
  // barsContainer.append('line').attr('y1', -gridChartOffset).attr('y2', yScale.rangeExtent()[1] + gridChartOffset).style('stroke', '#000');
};