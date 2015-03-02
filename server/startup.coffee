#
# Cron job that deletes temporary files from user exports
#
SyncedCron.add
  name: 'Delete temporary query files'
  schedule: (parser) ->
    parser.text 'every 20 seconds'
  job: ->
    fs = Npm.require('fs')
    dirPath = '../../../../../tmp/'
    fs.readdir dirPath, (err, files) ->
    	files.forEach (file)->
    		filePath = dirPath + file
    		if true # if file is outdated...
	    		console.log filePath
	    		fs.unlink filePath, (err) ->
					# if err then PANIC!
			  	return
				return
    	return

# Start croning
SyncedCron.start()