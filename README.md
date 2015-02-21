Jata Data Visualizer
====================
Run this command to parse your csv to json:
`python parser.py filename.csv`

Run this command to load the json into the data base:

`mongoimport -h localhost:3001 --db meteor --collection data < SampleTable.json`

Note that the host may vary. This local host is based on meteor running on localhost 3000. If 3001 doesn't work try 3002. Or you can run meteor and in another temrinal window run -- `meteor mongo` -- which will return the IP of the database you are connecting to, use the digits after the `:` and before the `/`
