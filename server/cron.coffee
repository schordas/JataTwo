#
# Cron job that deletes temporary files from user exports
# 
SyncedCron.add
  name: 'Delete temporary query files'
  schedule: (parser) ->
    parser.text 'at 11:59 pm'
  job: ->
    fs = Npm.require('fs')
    dirPath = '../../../../../tmp/'
    fs.readdir dirPath, (err, files) ->
      files.forEach (file)->
      		filePath = dirPath + file
  	    	fs.unlink filePath, (err) ->
    				if err
    					console.log 'Error deleting file during cron job. File: ' + file
  				return
      return
# Start croning
SyncedCron.start()