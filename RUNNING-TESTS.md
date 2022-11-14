docker-compose build
docker-compose up

Initialize timeld and get the authorization key:
docker exec -it federation-tests_timeld-cli_1 "/usr/local/bin/node" "/timeld/init.mjs"

docker exec -u www-data -it federation-tests_tikiwiki_1 "/bin/sh" "/usr/local/bin/tiki-init.sh"

On tikiwiki:
http://localhost:8180/ and login with admin/secret
http://localhost:8180/tiki-admin.php?page=security#content_admin1-api
create an API token

On prejournal:
In /app/.env:
- update the TIMELD_PASSWORD value to the auth.key value from timeld;
- update the WIKI_TOKEN value to the token from tikiwiki

From outside:
curl -d'["alice","alice123"]' http://localhost:8280/v1/register
curl -d'["23 Sep 2022","stichting","Federated Timesheets", 8, "hard work"]' http://alice:alice123@localhost:8280/v1/worked-hours
#curl -d'["alice"]' http://alice:alice123@localhost:8280/v1/push-to-timeld

Check the time entry on timeld:
docker exec -it federation-tests_timeld-cli_1 "/usr/local/bin/node" "/timeld/report.mjs"

Check the time entry on tikiwiki:
http://localhost:8180/tiki-view_tracker.php?trackerId=1
