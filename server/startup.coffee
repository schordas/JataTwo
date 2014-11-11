# On server startup, if the database is empty, create some initial data.
if Meteor.isServer
  Meteor.startup ->
    #Converter Class
    Converter = Meteor.npmRequire('csvtojson').core.Converter
    fs = Meteor.npmRequire('fs')

    csvFileName = "*./public/data.csv"
    fileStream = fs.createReadStream(csvFileName)

    #new converter instance
    csvConverter = new Converter(constructResult: true)

    #end_parsed will be emitted once parsing finished
    csvConverter.on "end_parsed", (jsonObj) ->
      console.log jsonObj #here is your result json object
      return

    #read from file
    fileStream.pipe csvConverter
  return

    # load init data from file
    # Nothing in db or clear db
    # collectionFS to upload a file
    # npm .require 'fs'
    # fs.readFile
    # parse file
    # add entries to data collection
    # delete the file form collectionFS
    # node csv to json
