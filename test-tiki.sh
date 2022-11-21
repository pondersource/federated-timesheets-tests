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

echo "--- Adding credentials to tiki for timeld and prejournal"
docker exec -u www-data -it federated-timesheets-tests_tikiwiki_1 "/bin/sh" "/profile/addusers.sh"
echo "$TIMELD_PASSWORD" > timeld-key
docker cp timeld-key federated-timesheets-tests_tikiwiki_1:/profile/timeld-key
docker exec -u www-data -it federated-timesheets-tests_tikiwiki_1 "php" "/profile/add-credentials.php"

# FIXME: Add this
echo "--- Entering timesheet entry in tiki"
curl -X POST -H "Authorization: Bearer testnet-supersecret-token" -d 'fields[tsUser]=alice&fields[tsProject]=timesheet&fields[tsDate]=1668460845&fields[tsDescription]=This%20is%20the%20description%20to%20check%20for&fields[tsDuration]=%7B%22hours%22%3A2%2C%22minutes%22%3A0%7D&fields[tsStartTime]=1668460845&fields[tsEndTime]=1668468045' http://localhost:8180/api/trackers/1/items

# FIXME: Add this
echo "--- Triggering federation exports for tiki"
curl -X GET -H "Authorization: Bearer testnet-supersecret-token" http://localhost:8180/api/tabulars/3/export
curl -X GET -H "Authorization: Bearer testnet-supersecret-token" http://localhost:8180/api/tabulars/4/export

echo "--- Fetching report from prejournal"
curl -d'["0"]' http://alice:alice123@localhost:8280/v1/print-timesheet-json > prejournal-report.json

echo "--- Fetching report from timeld"
docker exec -it federated-timesheets-tests_timeld-cli_1 "/usr/local/bin/node" "/timeld/report.mjs" > timeld-report.txt

PREJOURNAL_VALIDATED=`grep -c "This is the description to check for" prejournal-report.json`
TIMELD_VALIDATED=`grep -c "This is the description to check for" timeld-report.txt`

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
if [ $TIMELD_VALIDATED == '1' ]
then
  echo
  echo "------------------------------"
  echo "Federation to TimeLD validated"
  echo "------------------------------"
  cat timeld-report.txt
  echo "------------------------------"
else
  echo
  echo "------------------------------"
  echo "Federation to TimeLD failed"
  echo "------------------------------"
  cat timeld-report.txt
  echo "------------------------------"
fi

rm timeld-key
rm testnet.env
rm prejournal-report.json
rm timeld-report.txt
docker-compose down

if [ $PREJOURNAL_VALIDATED == '1' ] && [ $TIMELD_VALIDATED == '1' ]
then
  echo
  echo "-----------------------------"
  echo "Tiki federation was a success"
  echo "-----------------------------"
  echo
  exit 0
else
  echo
  echo "----------------------"
  echo "Tiki federation failed"
  echo "----------------------"
  echo
  exit 1
fi
