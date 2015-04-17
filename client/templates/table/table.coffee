Template.table.helpers
	settings: ->
		return { collection: Data.find(Session.get 'query'), rowsPerPage: 10, showFilter: false, fields: fields }	
