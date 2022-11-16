#!/bin/bash
docker-compose up -d

echo "--- Initializing timeld"
export TIMELD_PASSWORD=`docker exec -it federation-tests_timeld-cli_1 "/usr/local/bin/node" "/timeld/init.mjs"`
echo "--- Extracted key: $TIMELD_PASSWORD"

echo "--- Installing tikiwiki"
docker exec -u www-data -it federation-tests_tikiwiki_1 "/bin/sh" "/usr/local/bin/tiki-init.sh"
echo "--- Setting up environment for prejournal"
cp prejournal/testnet.env testnet.env
echo "TIMELD_PASSWORD=$TIMELD_PASSWORD" >> testnet.env
docker cp testnet.env federation-tests_prejournal_1:/app/.env
curl -d'["alice","alice123"]' http://localhost:8280/v1/register

echo "Entering timesheet entry"
curl -d'["23 Sep 2022","stichting","Federated Timesheets", 8, "This is the description to check for"]' http://alice:alice123@localhost:8280/v1/worked-hours

echo "Fetching report from timeld"
docker exec -it federation-tests_timeld-cli_1 "/usr/local/bin/node" "/timeld/report.mjs" > timeld-report.txt
echo "Fetching report from tikiwiki"
curl -H "Authorization: Bearer testnet-supersecret-token" http://localhost:8180/api/trackers/1 > tiki-report.json

TIMELD_VALIDATED=`grep -c "This is the description to check for" timeld-report.txt`
TIKI_VALIDATED=`grep -c "This is the description to check for" tiki-report.json`

if [ $TIMELD_VALIDATED == '1' ]
then
  echo
  echo "------------------------------"
  echo "Federation to TimeLD validated"
  echo "------------------------------"
  echo
else
  echo
  echo "------------------------------"
  echo "Federation to TimeLD failed"
  echo "------------------------------"
  echo
fi
if [ $TIKI_VALIDATED == '1' ]
then
  echo
  echo "--------------------------------"
  echo "Federation to tikiwiki validated"
  echo "--------------------------------"
  echo
else
  echo
  echo "--------------------------------"
  echo "Federation to tikiwiki failed"
  echo "--------------------------------"
  echo
fi

rm testnet.env
rm timeld-report.txt
rm tiki-report.json
docker-compose down
if [ $TIMELD_VALIDATED == '1' ] && [ $TIKI_VALIDATED == '1' ]
then
  echo
  echo "-----------------------------------"
  echo "Prejournal federation was a success"
  echo "-----------------------------------"
  echo
  exit 0
else
  echo
  echo "----------------------------"
  echo "Prejournal federation failed"
  echo "----------------------------"
  echo
  exit 1
fi
