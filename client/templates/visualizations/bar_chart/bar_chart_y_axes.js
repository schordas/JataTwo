Template.barChartYAxes.helpers({
  yAxes: function() {
  	return barChartYAxes.get();
  },
  isSelected: function(option, index) {
    if (barChartYAxes.get()[index] != undefined) {
      if (barChartYAxes.get()[index].get() === option) {
        return true;
      } else {
        return false;
      }
    }
  },
  rangeWithIndex: function(range, index) {
    var a = [];
    range.forEach(function(d) {
      a.push(
        {
          label: d.label,
          index: index
        }
        );
    });
    return a;
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
    if (e.target.getAttribute('class') == 'add-btn') {
      var temp = barChartYAxes.get();
      temp.push(new ReactiveVar('MTD Burdened Costs'));
      barChartYAxes.set(temp);
    } else if (e.target.getAttribute('class') == 'remove-btn') { 
      if (barChartYAxes.get().length > 1) {
        var index = e.target.getAttribute('index');
        var temp = barChartYAxes.get();
        temp.splice(index, 1);
        barChartYAxes.set(temp);
      }
    }
  }
});