barChartXAxis = new ReactiveVar('Fiscal Year');
barChartYAxis = new ReactiveVar('MTD Burdened Costs');
barChartDrillDown = new ReactiveVar('level2');

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
  var dataHierTemp = DataHierarchy.find().fetch();
  var dataHierarchy = [];
  dataHierTemp.forEach(function(item) {
    dataHierarchy[item["_id"]] = item;
  });
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
    //var expType = DataHierarchy.findOne({_id : d["Expenditure Type"]});
    var expType = dataHierarchy[d["Expenditure Type"]];
    if (expType != undefined) {
      if (data[index][expType[barChartDrillDown.get()]] == undefined) {
        data[index][expType[barChartDrillDown.get()]] = 0;
      }
      data[index][expType[barChartDrillDown.get()]] += d[barChartYAxis.get()];
    }
  });
  
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
    return key !== "label";
  }));
  data.forEach(function(d) {
    var y0 = 0;
    d.levelCat = color.domain().map(function(name) {
      if (d[name] == undefined) {
        return {name: name, y0: 0, y1: 0};
      }
      return {name: name, y0: y0, y1: y0 += +d[name]};
    });
    d.total = d.levelCat[d.levelCat.length - 1].y1;
  });
  data.sort(function(a, b) {
    return b.total - a.total; });

  x.domain(data.map(function(d) { return d.label; }));
  y.domain([0, d3.max(data, function(d) { return d.total; })]);

  svg.append("g")
      .attr("class", "x axis")
      .attr("transform", "translate(0," + height + ")")
      .call(xAxis)

  svg.append("g")
      .attr("class", "y axis")
      .call(yAxis)

  var state = svg.selectAll(".state")
      .data(data)
    .enter().append("g")
      .attr("class", "g")
      .attr("transform", function(d) { return "translate(" + x(d.label) + ",0)"; });

  state.selectAll("rect")
      .data(function(d) { return d.levelCat; })
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




};