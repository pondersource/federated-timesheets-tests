#!/bin/bash
docker-compose up -d
export TIMELD_PASSWORD=`docker exec -it federation-tests_timeld-cli_1 "/usr/local/bin/node" "/timeld/init.mjs"`
docker exec -u www-data -it federation-tests_tikiwiki_1 "/bin/sh" "/usr/local/bin/tiki-init.sh"
cp prejournal/testnet.env testnet.env
echo "TIMELD_PASSWORD=$TIMELD_PASSWORD" >> testnet.env
docker cp testnet.env federation-tests_prejournal_1:/app/.env
curl -d'["alice","alice123"]' http://localhost:8280/v1/register
curl -d'["23 Sep 2022","stichting","Federated Timesheets", 8, "hard work"]' http://alice:alice123@localhost:8280/v1/worked-hours
docker exec -it federation-tests_timeld-cli_1 "/usr/local/bin/node" "/timeld/report.mjs"
curl -H "Authorization: Bearer testnet-supersecret-token" http://localhost:8180/api/trackers/1
rm testnet.env
