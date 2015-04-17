Meteor.startup(function() {
	/*
	*	Define DataHierarchy - used for data drilldown
	* 	Uses the file: data/data_hierarchy.csv
	*/
	DataHierarchy.remove({});
	if ( DataHierarchy.find().count() == 0 ) {
		var filePath = "../../../../../data/data_hierarchy.csv";
		var fs = Npm.require('fs');
		fs.readFile(filePath, 'utf8', Meteor.bindEnvironment(function(err, data) {
            if (err) {
            	console.log(err);
            }
            var isFirstLine = true;
            data.toString().split("\r").forEach(function(line) {
            	if (isFirstLine) {
            		isFirstLine = false;
            	} else {
	            	var fields = line.split(",");
					DataHierarchy.insert(
						{
							_id : fields[2],
							level3 : fields[2],
							level2 : fields[1],
							level1 : fields[0]

						});
            	}
            	// end ForEach
            	});
        	}));
	} // end if count == 0
}); // end Meteor.startup

