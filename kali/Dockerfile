FROM kalilinux/kali-rolling:latest

# зеркало
RUN printf '%s\n' \
    'Types: deb' \
    'URIs: http://mirror.truenetwork.ru/kali/' \
    'Suites: kali-rolling' \
    'Components: main contrib non-free non-free-firmware' \
    'Signed-By: /usr/share/keyrings/kali-archive-keyring.gpg' \
    > /etc/apt/sources.list.d/kali.sources

RUN printf '%s\n' \
    'Acquire::Retries "10";' \
    'Acquire::http::Timeout "120";' \
    'Acquire::https::Timeout "120";' \
    'Acquire::http::ConnectTimeout "30";' \
    'Acquire::http::Pipeline-Depth "0";' \
    'Acquire::ForceIPv4 "true";' \
    > /etc/apt/apt.conf.d/99ru-tuning

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    ca-certificates curl wget jq nmap file git python3 \
    redis-tools smbclient awscli openjdk-11-jre-headless \
    python3-redis python3-boto3 python3-requests python3.14-venv \
    python2.7 python2.7-dev gcc libc6-dev \
    metasploit-framework && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Python2-инструменты
RUN curl -sS https://bootstrap.pypa.io/pip/2.7/get-pip.py | python2.7 && \
    pip2 install --no-cache-dir 'virtualenv<20.0'

# Проверка, что всё на месте
RUN set -e; \
    for b in nmap curl wget jq file git python3 redis-cli smbclient aws java pip2; do \
    command -v "$b" >/dev/null || { echo "MISSING: $b"; exit 1; }; \
    done; \
    python3 -c 'import redis, boto3, requests; print("py3 libs OK:", redis.__version__, boto3.__version__, requests.__version__)'; \
    java -version; nmap --version | head -1; redis-cli --version

CMD ["tail", "-f", "/dev/null"]