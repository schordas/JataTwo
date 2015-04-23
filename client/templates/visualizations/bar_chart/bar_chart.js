barChartXAxis = new ReactiveVar('Period Nbr');
//yAxis
barChartYAxes = new ReactiveVar( [ new ReactiveVar('MTD Burdened Costs') ] ); // array of arrays
barChartDrillDown = new ReactiveVar('level2');
yearsInQuery = new ReactiveVar([]);
barChartSelectedYear = new ReactiveVar("all");

Template.barChart.rendered = function() {
  Meteor.autorun(function() {
    // Bar chart will resize on browser window resize
    window.addEventListener('resize', renderBarChart, false);
    //
    if (dataIsLoaded.get()) {
      renderBarChart();
    }
  });
};

function getDataByYValue(yValue) {
  var queryData = Data.find(Session.get('query')).fetch();
  var data = [];
  var indexMap = []; // maps the level category id to index
  var dataHierarchy = [];
  DataHierarchy.find().fetch().forEach(function(item) {
    dataHierarchy[item["_id"]] = item;
    //console.log(item[1]);
  });
  // Convert the data to follow the appropriate format as defined here: http://bl.ocks.org/mbostock/3886208
  var uniqueYears = [];
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
    var expType = dataHierarchy[d["Expenditure Type"]];
    //
    if (expType != undefined) {
      if ( // add to the sum IF the following
        barChartXAxis.get() != 'Period Nbr' ||  // if period is not the x axis,
        barChartSelectedYear.get() == d['Fiscal Year'] || // if period is the x-axis and the years match
        isNaN(barChartSelectedYear.get()) // all years is selected
        ) {
        if (data[index][expType[barChartDrillDown.get()]] == undefined) {
          data[index][expType[barChartDrillDown.get()]] = 0;
        }
        data[index][expType[barChartDrillDown.get()]] += d[yValue];
      }
    }
    /*
    * Add to year array
    */
    if ( uniqueYears.indexOf(d["Fiscal Year"]) < 0 ) {
      uniqueYears.push( d["Fiscal Year"] );
    }
  });
  uniqueYears.sort();
  uniqueYears.reverse();
  yearsInQuery.set(uniqueYears);
  return data;
}

function renderBarChart() {
  /*
  * Remove the old bar chart
  */
  if (d3.select('#bar-chart-svg')[0][0] !== null) {
    var barChartContainer = document.getElementById('bar-chart');
    barChartContainer.removeChild(document.getElementById('bar-chart-svg'));
  }

  /*
  * Determine columns
  */
  var numColumns = barChartYAxes.get().length;

  /*
  * Prepare Data
  */
  var dataArray = [];
  var maxYValue = 0;
  for (i = 0; i < numColumns; ++i) {
    dataArray[i] = getDataByYValue(barChartYAxes.get()[i].get());
    var barChartDomain = d3.keys(dataArray[i][0]).filter(function(key) {
      return key !== "label";
    });
    dataArray[i].forEach(function(d) { // TODO move this into the getDataByYValue function to speed things up
      var y0 = 0;
      d.levelCat = barChartDomain.map(function(name) {
        if (d[name] == undefined) {
          return {name: name, y0: 0, y1: 0, value: 0, bar: d.label};
        }
        return {name: name, y0: y0, y1: y0 += +d[name], value: d[name], bar: d.label};
      });
      d.total = d.levelCat[d.levelCat.length - 1].y1;
      if (d.total > maxYValue) {
        maxYValue = d.total;
      }
    });
  }

  /*
  * Various D3 Initializations
  */
  //
  var maxLabelLength = d3.max(dataArray[0], function(d) { return String(d.label).length; });
  var maxLabelHeight = maxLabelLength * ((maxLabelLength > 8) ? 4 : 3); // used for x-axis labels that overflow
  //
  var legendWidth = 74;
  //
  var containerWidth = document.getElementById('bar-chart').offsetWidth;
  var containerHeight = (containerWidth / 3) + maxLabelHeight;
  //
  var margin = {top: 20, right: 20, bottom: 30 + maxLabelHeight, left: 40},
    width = containerWidth - margin.left - margin.right - legendWidth,
    height = containerHeight - margin.top - margin.bottom;

  var x = d3.scale.ordinal()
      .rangeRoundBands([0, width], .1);

  var y = d3.scale.linear()
      .rangeRound([height, 0]);

  var xAxis = d3.svg.axis()
      .scale(x)
      .orient("bottom")
      .tickFormat(d3.format(".1s"));;

  var yAxis = d3.svg.axis()
      .scale(y)
      .orient("left")
      .tickFormat(d3.format(".2s"));// line thickness

  //
  var tip = d3.tip()
    .attr('class', 'd3-tip')
    .offset([-10, 0])
    .html(function(d) {
      return "<strong>" + barChartXAxis.get() + ": </strong><span style='color:red'>" + d.bar + "</span><br><strong>" + d.name + ":</strong> <span style='color:red'>" + addCommas(d.value) + "</span>";
    })
  // The main event!
  var svg = d3.select("#bar-chart").append("svg")
      .attr("id", "bar-chart-svg")
      .attr("width", width + margin.left + margin.right)
      .attr("height", height + margin.top + margin.bottom)
    .append("g")
      .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

  svg.call(tip);


  /*
  * Determine domain and range
  */
  var color = d3.scale.ordinal()
    .domain([0,barChartDomain.length])
    .range(["#2484c1", "#65a620", "#7b6888", "#a05d56", "#961a1a", "#d8d23a", "#e98125", "#d0743c", "#635222", "#6ada6a",
        "#0c6197", "#7d9058", "#207f33", "#44b9b0", "#bca44a", "#e4a14b", "#a3acb2", "#8cc3e9", "#69a6f9", "#5b388f",
        "#546e91", "#8bde95", "#d2ab58", "#273c71", "#98bf6e", "#4daa4b", "#98abc5", "#cc1010", "#31383b", "#006391",
        "#c2643f", "#b0a474", "#a5a39c", "#a9c2bc", "#22af8c", "#7fcecf", "#987ac6", "#3d3b87", "#b77b1c", "#c9c2b6",
        "#807ece", "#8db27c", "#be66a2", "#9ed3c6", "#00644b", "#005064", "#77979f", "#77e079", "#9c73ab", "#1f79a7"]);
  x.domain(dataArray[0].map(function(d) { return d.label; })); // TODO the first element might not have all the domains
  y.domain([0, maxYValue]);

  /*
  * Draw bars
  */
  for (i = 0; i < numColumns; ++i) {
    data = dataArray[i];

    var state = svg.selectAll(".state")
        .data(data)
      .enter().append("g")
        .attr("class", "g")
        .attr("transform", function(d) { return "translate(" + (x(d.label) + i * x.rangeBand()/numColumns) + ",0)"; });


    state.selectAll("rect")
        .data(function(d) { return d.levelCat; })
      .enter().append("rect")
        .attr("width", x.rangeBand()/numColumns)
        .attr("y", function(d) { return y(d.y1); })
        .attr("height", function(d) { return y(d.y0) - y(d.y1); })
        .style("fill", function(d,i) { return color(i); })
        .on('mouseover', tip.show)
        .on('mouseout', tip.hide);
  }

  /*
  * Draw Axes
  */
  svg.append("g")
    .attr("class", "x axis")
    .attr("transform", "translate(0," + height + ")")
    .call(xAxis)
    .selectAll("text")
          .style("text-anchor", "end")
          .attr("dx", "-.8em")
          .attr("dy", ".15em")
          .attr("transform", function(d) {
              return "rotate(-65)"
              });
  //
  svg.append("g")
    .attr("class", "y axis")
    .call(yAxis);

  /*
  * Draw Legend
  */
  var legend = svg.selectAll(".legend")
      .data(barChartDomain.slice().reverse())
    .enter().append("g")
      .attr("class", "legend")
      .attr("transform", function(d, i) { return "translate(0," + i * 20 + ")"; });

  legend.append("rect")
      .attr("x", width + legendWidth - 18)
      .attr("width", 18)
      .attr("height", 18)
      .style("fill", function(d,i) { return color(i);} );

  legend.append("text")
      .attr("x", width + legendWidth - 24)
      .attr("y", 9)
      .attr("dy", ".35em")
      .style("text-anchor", "end")
      .text(function(d) { return d; });

};

function addCommas(nStr)
{
  nStr += '';
  x = nStr.split('.');
  x1 = x[0];
  x2 = x.length > 1 ? '.' + x[1] : '';
  var rgx = /(\d+)(\d{3})/;
  while (rgx.test(x1)) {
    x1 = x1.replace(rgx, '$1' + ',' + '$2');
  }
  return x1 + x2;
}
