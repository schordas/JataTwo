import csv
import json

# Open the CSV
csvFile = open( 'SampleTableSmallFortyK.csv', 'rU' )
jsonFile = open('SampleTable.json','w')
# Change each fieldname to the appropriate field name. I know, so difficult.
fieldNames = ("Expenditure Type","Fiscal Year","Period Nbr","Project Number","Task Cognizant Org","Task Number","MTD Burdened Costs","MTD Actual FTE","MTD Hours","MTD Burdened Obligations","MTD Obligations","MTD EAC BurdenedPlan","MTD EAC Raw Plan","MTD EOC Burdened Plan","MTD EOC Raw Plan","MTD EAC FTE Plan","MTD EAC Hours Plan","MTD Burdened Cost Plan","MTD Burdened Oblg Plan","MTD FTE Plan","MTD Hours Plan","MTD Raw Cost Plan","MTD Raw Oblg Plan")

reader = csv.DictReader(csvFile, fieldNames)
# Parse the CSV into JSON
firstline = True
for row in reader:
    if firstline:
        firstline = False
        continue
    json.dump(row, jsonFile)
    jsonFile.write(',\n')
# out = json.dumps( [ row for row in reader ] )
# print "JSON parsed!"
# # Save the JSON
# f = open( '/Users/samuel_chordas/Current Classes/CSCI477a/JPL/SampleTable.json', 'w')
# f.write(out)
print "JSON saved!"
