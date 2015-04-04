Template.barChartDrillDown.helpers({
	drillDown: function() {
		return [
			{
				label: "Level 1",
				value: "level1"
			},
			{
				label: "Level 2",
				value: "level2"
			},
			{
				label: "Level 3",
				value: "level3"
			}
		];
	},
	isSelected: function(option) {
		return (barChartDrillDown.get() == option) ? true : false;
	}
});

Template.barChartDrillDown.events({
    'change select': function(e,t) {
    	console.log(t.find("[name=bar-chart-drill-down]"));
    	// barChartDrillDown.set( t.find("[name=bar-chart-x-axis]")?.value );
    }
 });