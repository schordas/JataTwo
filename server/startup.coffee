# On server startup, if the database is empty, create some initial data.
if Meteor.isServer
  @Fiber = Meteor.npmRequire("fibers")
  Meteor.startup ->
    #Converter Class
    if Data.find().count() is 0
      Converter = Meteor.npmRequire('csvtojson').core.Converter
      fs = Meteor.npmRequire('fs')
      csvFileName = '/Users/samuel_chordas/CurrentClasses/CSCI477a/JPL/SampleTable.csv'
      fileStream = fs.createReadStream(csvFileName)
      #new converter instance
      csvConverter = new Converter(constructResult: true)
      boundFunction = Meteor.bindEnvironment((jsonObj)->
        Data.insert x for x in jsonObj
        console.log("hey I'm fucking done bro")
        return
      , (e) ->
        throw e
        return
      )


      #end_parsed will be emitted once parsing finished
      csvConverter.on "end_parsed", (jsonObj) ->
        boundFunction jsonObj
        return
        # console.log jsonObj
        # Fiber ->
        #   Data.insert jsonObj
        #   return

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
