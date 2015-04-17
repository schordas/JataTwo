pieChartKey = new ReactiveVar('Period Nbr');
pieChartValue = new ReactiveVar('MTD Burdened Costs');

var pie;

Template.pieChart.rendered = function () {
	Meteor.autorun(function() {
		window.addEventListener('resize', drawPieChart, false);
		drawPieChart();
	});

};

function drawPieChart() {
	// Data
	var data = Data.find(Session.get('query')).fetch();
	var dataArray = [];
	var indexMap = [];
	if (pieChartKey.get().indexOf("level") > -1) { 
	// Drill down
		var dataHierarchy = [];
		DataHierarchy.find().fetch().forEach(function(item) {
			dataHierarchy[item["_id"]] = item;
		});
		// aggregate data
		data.forEach(function(d) {
			if (dataHierarchy[ d['Expenditure Type'] ] != undefined) {
				var key = dataHierarchy[ d['Expenditure Type'] ][ pieChartKey.get() ];
				if (dataArray[ indexMap[key] ] == undefined) {
					indexMap[key] = dataArray.length;
      				dataArray.push({
						label : String(key),
						value : 0
					});
				}
				dataArray[ indexMap[key] ].value += d[pieChartValue.get()];
			}
		});
	} else { 
	// normal key
		data.forEach(function(d) {
			var key = d[pieChartKey.get()];
			if (indexMap["_" + String(key)] == undefined) {
				indexMap["_" + String(key)] = dataArray.length;
				dataArray.push({
					label : String(key),
					value : 0
				});
			}
			dataArray[ indexMap["_" + String(key)] ].value += d[pieChartValue.get()];
		});


		// for (var d in data) {
		// 	var key = data[d][pieChartKey.get()];
		// 	if (indexMap["_" + String(key)] == undefined) {
		// 		indexMap["_" + String(key)] = data.length;
  //     			dataArray[ dataArray.length ] = {};
		// 		dataArray[ dataArray.length - 1 ] = {
		// 			label : String(key),
		// 			value : 0
		// 		};
		// 	}
		// 	dataArray[ indexMap["_" + String(key)] ].value += data[d][pieChartValue.get()];
		// }
	}

	// var finalData = [];
	// for (var d in dataArray) {
	// 	finalData.push(dataArray[d]);
	// }

	/*
	* Draw
	*/
	// Remove old chart
	if (pie != undefined) {
		pie.destroy();
	}
	//
	var pageWidth = document.getElementById('myPie').offsetWidth;
	var pieWidth = Math.floor(pageWidth / 2);
	var pieHeight = pieWidth;
	$('#myPie').css('min-height', pieHeight);

	pie = new d3pie("myPie",

		{
			header: {
				title: {
					text:    "",
					color:    "#333333",
					fontSize: 18,
					font:     "arial"
				},
				subtitle: {
					color:    "#666666",
					fontSize: 14,
					font:     "arial"
				},
				location: "top-center",
				titleSubtitlePadding: 8
			},
			footer: {
				text: 	  "",
				color:    "#666666",
				fontSize: 14,
				font:     "arial",
				location: "left"
			},
			size: {
				canvasHeight: pieHeight,
				canvasWidth: pieWidth,
				pieInnerRadius: 0,
				pieOuterRadius: null
			},
			data: {
				sortOrder: "none",
				smallSegmentGrouping: {
					enabled: false,
					value: 1,
					valueType: "percentage",
					label: "Other",
					color: "#cccccc"
				},

				// REQUIRED! This is where you enter your pie data; it needs to be an array of objects
				// of this form: { label: "label", value: 1.5, color: "#000000" } - color is optional
				content: dataArray
			},
			labels: {
				outer: {
					format: "label-percentage2",
					hideWhenLessThanPercentage: null,
					pieDistance: 30
				},
				inner: {
					format: null
				},
				mainLabel: {
					color: "#333333",
					font: "arial",
					fontSize: 10
				},
				percentage: {
					color: "#333333",
					font: "arial",
					fontSize: 10,
					decimalPlaces: 2
				},
				value: {
					color: "#cccc44",
					font: "arial",
					fontSize: 10
				},
				lines: {
					enabled: true,
					style: "curved",
					color: "segment" // "segment" or a hex color
				}
			},
			effects: {
				load: {
					effect: "default", // none / default
					speed: 1000
				},
				pullOutSegmentOnClick: {
					effect: "bounce", // none / linear / bounce / elastic / back
					speed: 300,
					size: 10
				},
				highlightSegmentOnMouseover: true,
				highlightLuminosity: -0.2
			},
			tooltips: {
				enabled: true,
				type: "placeholder", // caption|placeholder
				string: pieChartKey.get() + " {label}: {value}, {percentage}%",
				placeholderParser: null,
				styles: {
					fadeInSpeed: 250,
					backgroundColor: "#000000",
					backgroundOpacity: 0.5,
					color: "#efefef",
					borderRadius: 2,
					font: "arial",
					fontSize: 15,
					padding: 4
				}
			},

			misc: {
				colors: {
					background: null, // transparent
					segments: [
						"#2484c1", "#65a620", "#7b6888", "#a05d56", "#961a1a",
						"#d8d23a", "#e98125", "#d0743c", "#635222", "#6ada6a",
						"#0c6197", "#7d9058", "#207f33", "#44b9b0", "#bca44a",
						"#e4a14b", "#a3acb2", "#8cc3e9", "#69a6f9", "#5b388f",
						"#546e91", "#8bde95", "#d2ab58", "#273c71", "#98bf6e",
						"#4daa4b", "#98abc5", "#cc1010", "#31383b", "#006391",
						"#c2643f", "#b0a474", "#a5a39c", "#a9c2bc", "#22af8c",
						"#7fcecf", "#987ac6", "#3d3b87", "#b77b1c", "#c9c2b6",
						"#807ece", "#8db27c", "#be66a2", "#9ed3c6", "#00644b",
						"#005064", "#77979f", "#77e079", "#9c73ab", "#1f79a7"
					],
					segmentStroke: "#ffffff"
				},
				gradient: {
					enabled: false,
					percentage: 95,
					color: "#000000"
				},
				canvasPadding: {
					top: 5,
					right: 5,
					bottom: 5,
					left: 5
				},
				pieCenterOffset: {
					x: Math.floor( (pageWidth/2) - (pieWidth/2) ),
					y: 0
				},
				cssPrefix: null
			},
			callbacks: {
				onload: null,
				onMouseoverSegment: null,
				onMouseoutSegment: null,
				onClickSegment: null
			}


		} // end d3Pie config object

	); // end autorun
} // end drawPieChart
