# Proof of federation testing for the federated timesheets project
This repository contains a dockerized testing setup to validate federation within members of 'the club' of the federated timesheets project.

The club members are:
- prejournal (https://github.com/pondersource/prejournal/)
- timeld (https://github.com/m-ld/timeld/)
- tikiwiki (https://gitlab.com/tikiwiki/tiki) with https://profiles.tiki.org/Timesheets profile

The testing ecosystem consists of the following docker containers:
- prejournal - contains the main prejournal code
- prejournal-db - the postgresql database for prejournal
- tikiwiki - tikiwiki code
- tikiwiki-db - the mariadb for tikiwiki
- timeld-gateway - the timeld gateway and API
- timeld-cli - the CLI package for timeld
- mailhog - stores and sent emails and makes them available via API

From the outside, the following (web) services are exposed:
- localhost:8280 - prejournal
- localhost:8180 - tikiwiki
- localhost:8080 - timeld-gateway
- localhost:8025 - mailhog

Within the testnet, the services are found on:
- http://prejournal.local
- http://tikiwiki.local
- http://timeld-gateway.local:8080
- http://mailhog.local:8025

# Preperation
Run 
```
docker-compose build
```
to build up all the containers needed.

# Running tests
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

# Gotchas and how things work

## Prejournal
The prejournal used is a fork from the pondersource prejournal with some minor cleanups in there.

## TimeLD
TimeLD was a bit complicated to install and setup. The cli-client provides all the commands needed, but since it is an interactive client, it makes it a bit hard to script.
Our scripting is done by wrapping the cli-client in an node process and waiting a bit between commands. Output is parsed to grab the key.
The authentication code is sent by email, which is where mailhog comes in. Mailhog captures the message and makes it available via an API call. The message is parsed to extract the code, which is then fed to the cli-client to complete the registration.

## TikiWiki
Most things in tikiwiki can be added via API or console.php, but not everything.
We needed to setup an admin API token, which is now directly injected into the database.
The same goes for the credentials for prejournal and timeld.
The configuration of the tabulars for prejournal and timeld are a modified version of the profile, which contains the prejournal.local and timeld-gateway.local URLs instead of the 'real' ones.
