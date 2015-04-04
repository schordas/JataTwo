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
  var queryData = Data.find(Session.get('query')).fetch();
  var data = [];
  var indexMap = []; // maps the level category id to index
  queryData.forEach(function(d) {
    /*
    * If the x-axis item does not exist in data yet, add it to data
    */
    if ( indexMap["_" + String(d[ barChartXAxis.get() ])] == undefined) {
      // init label
      indexMap["_" + String(d[ barChartXAxis.get() ])] = data.length;
      data[data.length] = [];
      data[data.length - 1]["label"] = d[barChartXAxis.get()];
    } // end if exists
    var index = indexMap["_" + String(d[ barChartXAxis.get() ])];
    var expType = DataHierarchy.findOne({_id : d["Expenditure Type"]});
    if (expType != undefined) {
      if (data[index][expType["parent"]] == undefined) {
        data[index][expType["parent"]] = 0;
      }
      data[index][expType["parent"]] += d[barChartYAxis.get()];
    }
    });

  console.log(data);

  /*
  * Bar Chart
  */
  // Declare variables
  var margin = {top: 20, right: 20, bottom: 30, left: 40},
    width = 960 - margin.left - margin.right,
    height = 500 - margin.top - margin.bottom;

  var x = d3.scale.ordinal()
      .rangeRoundBands([0, width], .1);

  var y = d3.scale.linear()
      .rangeRound([height, 0]);

  var color = d3.scale.ordinal()
      .range(["#98abc5", "#8a89a6", "#7b6888", "#6b486b", "#a05d56", "#d0743c", "#ff8c00"]);

  var xAxis = d3.svg.axis()
      .scale(x)
      .orient("bottom");

  var yAxis = d3.svg.axis()
      .scale(y)
      .orient("left")
      .tickFormat(d3.format(".2s"));

  var svg = d3.select("#bar-chart").append("svg")
      .attr("id", "bar-chart-svg")
      .attr("width", width + margin.left + margin.right)
      .attr("height", height + margin.top + margin.bottom)
    .append("g")
      .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

  // Draw Bar Chart
  color.domain(d3.keys(data[0]).filter(function(key) {
    console.log(key);
    return key !== "label"; 
  }));
  data.forEach(function(d) {
    var y0 = 0;
    d.levelCat = color.domain().map(function(name) { 
      console.log(name);
      if (d[name] == undefined) {
        console.log(name + " doesn't exist here...");
        return {name: name, y0: 0, y1: 0};
      }
      return {name: name, y0: y0, y1: y0 += +d[name]}; 
    });
    d.total = d.levelCat[d.levelCat.length - 1].y1;
  });

  data.sort(function(a, b) { 
    console.log(a);
    console.log(b);
    return b.total - a.total; });

  x.domain(data.map(function(d) { return d.State; }));
  y.domain([0, d3.max(data, function(d) { return d.total; })]);

  svg.append("g")
      .attr("class", "x axis")
      .attr("transform", "translate(0," + height + ")")
      .call(xAxis);

  svg.append("g")
      .attr("class", "y axis")
      .call(yAxis)
    .append("text")
      .attr("transform", "rotate(-90)")
      .attr("y", 6)
      .attr("dy", ".71em")
      .style("text-anchor", "end")
      .text("Population");

  var state = svg.selectAll(".state")
      .data(data)
    .enter().append("g")
      .attr("class", "g")
      .attr("transform", function(d) { return "translate(" + x(d.State) + ",0)"; });

  state.selectAll("rect")
      .data(function(d) { return d.ages; })
    .enter().append("rect")
      .attr("width", x.rangeBand())
      .attr("y", function(d) { return y(d.y1); })
      .attr("height", function(d) { return y(d.y0) - y(d.y1); })
      .style("fill", function(d) { return color(d.name); });

  var legend = svg.selectAll(".legend")
      .data(color.domain().slice().reverse())
    .enter().append("g")
      .attr("class", "legend")
      .attr("transform", function(d, i) { return "translate(0," + i * 20 + ")"; });

  legend.append("rect")
      .attr("x", width - 18)
      .attr("width", 18)
      .attr("height", 18)
      .style("fill", color);

  legend.append("text")
      .attr("x", width - 24)
      .attr("y", 9)
      .attr("dy", ".35em")
      .style("text-anchor", "end")
      .text(function(d) { return d; });











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