Template.barChartYAxes.helpers({
  yAxes: function() {
  	return barChartYAxes.get();
  },
  isSelected: function(option, index) {
  	// TODO. Implement this...
   //  if (barChartYAxes.get()[index].get() === option) {
   //    return true;
   //  } else {
   //    return false;
   //  }
  }
});

Template.barChartYAxes.events({
  "change select": function(e) {
  	var index = e.target.getAttribute('index');
  	if (!isNaN(index)) {
  		barChartYAxes.get()[index].set(e.target.value);
  	}
  },
  "click button": function(e) {
  	var temp = barChartYAxes.get();
  	temp.push(new ReactiveVar('MTD Burdened Costs'));
  	barChartYAxes.set(temp);
  }
});