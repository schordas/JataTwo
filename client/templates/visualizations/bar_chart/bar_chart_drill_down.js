Template.barChartDrillDown.helpers({
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