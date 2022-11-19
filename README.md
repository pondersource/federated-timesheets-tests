# Preperation
docker-compose build

## 1. Testing federation from prejournal to timeld and tikiwiki 
The script to test the federation from prejournal to timeld and tikiwiki can
be run using
```
./test-prejournal.sh
```

What this script does is:
- setup the prejournal, timeld and tikiwiki environments.
- provide configuration and credentials in prejournal, so it knows how to push data to timeld and tikiwiki - including the generated timeld key
- add a timesheet entry in prejournal, which is automatically pushed to timeld and tikiwiki
- fetch the timesheet data from timeld and validate that our entry is in there
- fetch the timesheet data from tikiwiki and validate that our entry is in there
 
## 2. Testing federation from timeld to prejournal and tikiwiki
The script to test the federation from prejournal to timeld and tikiwiki can
be run using
```
./test-timeld.sh
```

What this script does is:
- setup the prejournal, timeld and tikiwiki environments.
- provide configuration and credentials in timeld, so it knows how to push data to prejournal and tikiwiki
- add a timesheet entry in timeld, which is automatically pushed to timeld and tikiwiki
- fetch the timesheet data from prejournal and validate that our entry is in there
- fetch the timesheet data from tikiwiki and validate that our entry is in there

## 3. Testing federation from tikiwiki to prejournal and timeld
The script to test the federation from tikiwiki to prejournal and timeld can be run using
```
./test-tiki.sh
```

What this script does is:
- setup the prejournal, timeld and tikiwiki environments.
- provied configuration and credentials in tikiwiki, so it knows how to push data to prejournal and timeld
- add a timesheet entry in tikiwiki via the API
- trigger the export of the timesheets to prejournal
- trigger the export of the timesheets to timeld
- fetch the timesheet data from prejournal and validate that our entry is in there
- fetch the timesheet data from timeld and vaildate that our entry is in there
