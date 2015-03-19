Template.barChartXAxis.helpers
	options: ->
		[
			{
				label: "Fiscal Year"
			},
			{
				label: "Period Nbr"
			},
			{
				label: "Project Number"
			},
			{
				label: "Expenditure Type"
			},
			{
				label: "Task Cognizant Org"
			}
		] 
	isSelected: (option)->
		if (barChartXAxis.get() == option) then true else false
