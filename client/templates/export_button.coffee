#
# Initialize the behavior of the Export Buttons
#
window.onload = (e)->
	json = document.getElementById 'json-export'
	json.onclick = ->
		console.log 'clicked! JSON'
		return false # prevents default behavior
	csv = document.getElementById 'csv-export'
	csv.onclick = ->
		console.log 'clicked! CSV'
		return false # prevents default behavior
	return
