docker-compose build
docker-compose up

On timeld-cli:
timeld config --gateway http://timeld-gateway.local:8080
timeld config --user prejournal
timeld admin
-> enter e-mail, grab code from mailhog and enter the code
timeld config
-> note the key auth.key value;

On tikiwiki:
tiki-init.sh
Go to http://localhost:8180/tiki-admin.php?page=security#content_admin1-api
create an API token

On prejournal:
In /app/.env:
- update the TIMELD_PASSWORD value to the auth.key value from timeld;
- update the WIKI_TOKEN value to the token from tikiwiki

From outside:
curl -d'["alice","alice123"]' http://localhost:8280/v1/register
curl -d'["23 Sep 2022","stichting","Federated Timesheets", 8, "hard work"]' http://alice:alice123@localhost:8280/v1/worked-hours
#curl -d'["alice"]' http://alice:alice123@localhost:8280/v1/push-to-timeld

On timeld-cli:
timeld open timesheet
> report

