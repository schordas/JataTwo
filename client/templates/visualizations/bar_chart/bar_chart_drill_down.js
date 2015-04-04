Template.barChartDrillDown.helpers({
  drillDown: function() {
    return [
      {
        label: 'Level 1',
        value: 'level1'
      }, 
      {
        label: 'Level 2',
        value: 'level2'
      }, 
      {
        label: 'Level 3',
        value: 'level3'
      }
    ];
  },
  isSelected: function(option) {
    if (barChartDrillDown.get() === option) {
      return true;
    } else {
      return false;
    }
  }
});

Template.barChartDrillDown.events({
  "change select": function(e, t) {
  	var value = t.find("[name=bar-chart-drill-down]").value;
  	if (value == "level3") {
  		value = "_id";
  	}
    barChartDrillDown.set(value);
  }
});