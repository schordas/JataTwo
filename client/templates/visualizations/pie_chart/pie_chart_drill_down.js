Template.pieChartDrillDown.helpers({
  isSelected: function(option) {
    if (pieChartDrillDown.get() === option) {
      return true;
    } else {
      return false;
    }
  }
});

Template.pieChartDrillDown.events({
  "change select": function(e, t) {
  	var value = t.find("[name=pie-chart-drill-down]").value;
  	if (value == "level3") {
  		value = "_id";
  	}
    pieChartDrillDown.set(value);
  }
});