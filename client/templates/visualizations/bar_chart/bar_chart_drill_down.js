Template.barChartDrillDown.rendered = function() {
  $('#drill-down-info').popover({
    title: "Levels",
    content: "1: Labor, Services, Procurement,...<br />2: Travel, Charegebacks, JPL,...<br />3:  Expenditure Types",
    html: true,
    placement: 'top'
  });
}

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
  "change select": function(e) {
    barChartDrillDown.set(e.target.value);
  }
});
