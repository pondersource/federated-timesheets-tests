docker-compose build
docker-compose up

Initialize timeld and get the authorization key:
docker exec -it federation-tests_timeld-cli_1 "/usr/local/bin/node" "/timeld/init.mjs"

Initialize tikiwiki:
docker exec -u www-data -it federation-tests_tikiwiki_1 "/bin/sh" "/usr/local/bin/tiki-init.sh"

On prejournal:
In /app/.env:
- update the TIMELD_PASSWORD value to the auth.key value from timeld;

From outside:
curl -d'["alice","alice123"]' http://localhost:8280/v1/register
curl -d'["23 Sep 2022","stichting","Federated Timesheets", 8, "hard work"]' http://alice:alice123@localhost:8280/v1/worked-hours
#curl -d'["alice"]' http://alice:alice123@localhost:8280/v1/push-to-timeld

Check the time entry on timeld:
docker exec -it federation-tests_timeld-cli_1 "/usr/local/bin/node" "/timeld/report.mjs"

Check the time entry on tikiwiki:
curl -H "Authorization: Bearer testnet-supersecret-token" http://localhost:8180/api/trackers/1
