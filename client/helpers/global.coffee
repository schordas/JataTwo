#
# dataIsLoaded is set to true when subscription .ready() is true
#						 false when a new query is made
#
@dataIsLoaded = new ReactiveVar(false)

Template.registerHelper 'dataIsLoaded', ->
	return dataIsLoaded.get()