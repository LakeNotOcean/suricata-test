set -e
cd "$(dirname "$0")"

rm -rf offline
mkdir -p offline/wheels

echo "[*] Клонирую эксплойт и форк impacket..."
git clone --depth 1 https://github.com/opsxcq/exploit-CVE-2017-7494.git offline/exploit-CVE-2017-7494
git clone --depth 1 https://github.com/opsxcq/impacket.git offline/impacket

echo "[*] Скачиваю wheel'ы для python 2.7..."

curl -sSL -o offline/wheels/pycryptodome-3.24.1-cp27-cp27mu-manylinux2010_x86_64.whl \
    https://files.pythonhosted.org/packages/73/5b/862776567f56a966efa65d220f525d708c48923ccfab15beb5c1a3726c84/pycryptodome-3.24.1-cp27-cp27mu-manylinux2010_x86_64.whl
curl -sSL -o offline/wheels/pyasn1-0.4.8-py2.py3-none-any.whl \
    https://files.pythonhosted.org/packages/62/1e/a94a8d635fa3ce4cfc7f506003548d0a2447ae76fd5ca53932970fe3053f/pyasn1-0.4.8-py2.py3-none-any.whl
curl -sSL -o offline/wheels/six-1.17.0-py2.py3-none-any.whl \
    https://files.pythonhosted.org/packages/b7/ce/149a00dd41f10bc29e5921b496af8b574d8413afcd5e30dfa0ed46c2cc5e/six-1.17.0-py2.py3-none-any.whl

echo "[*] Копирую в контейнер attacker и устанавливаю без сети..."
docker exec attacker rm -rf /tmp/offline
docker cp offline attacker:/tmp/offline
docker exec attacker bash -c '
    pip2 install --no-index --find-links /tmp/offline/wheels pycryptodome pyasn1==0.4.8 six &&
    pip2 install --no-deps /tmp/offline/impacket &&
    mkdir -p /opt/exploit-CVE-2017-7494 &&
    cp -r /tmp/offline/exploit-CVE-2017-7494/. /opt/exploit-CVE-2017-7494/ &&
    chmod +x /opt/exploit-CVE-2017-7494/exploit.py &&
    python2.7 -c "from impacket.smbconnection import SMBConnection; print(\"[+] offline install OK\")"
'
