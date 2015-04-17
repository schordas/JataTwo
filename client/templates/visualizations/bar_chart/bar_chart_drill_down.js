Template.barChartDrillDown.rendered = function() {
  var level1 = [];
  var level2 = [];
  var l1Str = "";
  var l2Str = "";
  DataHierarchy.find().fetch().forEach(function(item) {
    // check for level 1 item, if it exists, exclude it
    if ($.inArray(item["level1"], level1) == -1){
      level1.push(item["level1"]);
      console.log(item["level1"]);
      // sanity check
      if (item["level1"] != undefined){
        // append to string
        l1Str += item["level1"];
        l1Str += ", ";
      }

    }
    // Check array for the level 2 item, if it exists, excluded it
    if ($.inArray(item["level2"], level2) == -1){
      level2.push(item["level2"]);
      // sanity check
      if (item["level2"] != undefined){
        //append to string
        l2Str += item["level2"];
        l2Str += ", ";
      }
    }
  });
  // Chop off last comma from strings
  l1Str = l1Str.substring(0,l1Str.length - 2);
  l2Str = l2Str.substring(0,l2Str.length - 2);
  $('#drill-down-info').popover({
    title: "Levels",
    content: "<b>Level 1:</b> " + l1Str + "<br /><b>Level 2:</b> " + l2Str,
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
