# директория с логами
curl -sL "http://172.20.0.106:3000/support/logs/"

# скачивание access log и audit.json
curl -sL "http://172.20.0.106:3000/support/logs/access.log.$(date +%F)" -o access.log
cat access.log
curl -sL "http://172.20.0.106:3000/support/logs/audit.json" -o audit.json
jq . audit.json
