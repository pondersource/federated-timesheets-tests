#!/bin/bash
docker-compose -p federated-timesheets-tests up -d

echo "--- Initializing timeld"
export TIMELD_PASSWORD=`docker exec -it federated-timesheets-tests_timeld-cli_1 "/usr/local/bin/node" "/timeld/init.mjs"`
docker exec -it federated-timesheets-tests_timeld-cli_1 "/usr/local/bin/node" "/timeld/report.mjs"
echo "--- Extracted key: $TIMELD_PASSWORD"

echo "--- Installing tikiwiki"
docker exec -u www-data -it federated-timesheets-tests_tikiwiki_1 "/bin/sh" "/usr/local/bin/tiki-init.sh"

echo "--- Setting up environment for prejournal"
cp prejournal/testnet.env testnet.env
docker cp testnet.env federated-timesheets-tests_prejournal_1:/app/.env
curl -d'["alice","alice123"]' http://localhost:8280/v1/register

echo "--- Connecting timeld to prejournal and tiki"
docker exec -it federated-timesheets-tests_timeld-cli_1 "/usr/local/bin/node" "/timeld/connect-prejournal.mjs"
docker exec -it federated-timesheets-tests_timeld-cli_1 "/usr/local/bin/node" "/timeld/connect-tiki.mjs"

echo "--- Entering timesheet entry in timeld"
docker exec -it federated-timesheets-tests_timeld-cli_1 "/usr/local/bin/node" "/timeld/timesheet-entry.mjs"

echo "--- Fetching report from prejournal"
curl -d'["0"]' http://alice:alice123@localhost:8280/v1/print-timesheet-json > prejournal-report.json

echo "--- Fetching report from tikiwiki"
curl -H "Authorization: Bearer testnet-supersecret-token" http://localhost:8180/api/trackers/1 > tiki-report.json

PREJOURNAL_VALIDATED=`grep -c "This is the description to check for" prejournal-report.json`
TIKI_VALIDATED=`grep -c "This is the description to check for" tiki-report.json`

if [ $PREJOURNAL_VALIDATED == '1' ]
then
  echo
  echo "----------------------------------"
  echo "Federation to prejournal validated"
  echo "----------------------------------"
  cat prejournal-report.json
  echo "----------------------------------"
else
  echo
  echo "-------------------------------"
  echo "Federation to prejournal failed"
  echo "-------------------------------"
  cat prejournal-report.json
  echo "-------------------------------"
fi
if [ $TIKI_VALIDATED == '1' ]
then
  echo
  echo "--------------------------------"
  echo "Federation to tikiwiki validated"
  echo "--------------------------------"
  cat tiki-report.json
  echo "--------------------------------"
else
  echo
  echo "------------------------------"
  echo "Federation to tikiwiki failed"
  echo "------------------------------"
  cat tiki-report.json
  echo "------------------------------"
fi

rm testnet.env
rm prejournal-report.json
rm tiki-report.json
docker-compose down

if [ $PREJOURNAL_VALIDATED == '1' ] && [ $TIKI_VALIDATED == '1' ]
then
  echo
  echo "-------------------------------"
  echo "TimeLD federation was a success"
  echo "-------------------------------"
  echo
  exit 0
else
  echo
  echo "------------------------"
  echo "TimeLD federation failed"
  echo "------------------------"
  echo
  exit 1
fi
