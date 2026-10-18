# suricata-test

Docker-лаборатория для проверки сетевых правил Suricata (IDS/IPS): атакующий хост на Kali, набор уязвимых сервисов-жертв и Suricata в режиме NFQUEUE (`-q 2`), события — в Evebox.

## Состав

| Контейнер | IP | Назначение |
|---|---|---|
| attacker | 172.20.0.10 | Kali, скрипты атак смонтированы в `/home/attacks` |
| victim-activemq | 172.20.0.101 | ActiveMQ 5.16.5 (CVE-2023-46604), 61616, 8161 |
| victim-redis | 172.20.0.102 | Redis 5.0.7 без аутентификации, 6379 |
| victim-minio-node1…3 | 172.20.0.103, .113, .114 | MinIO (CVE-2023-28432), 9000, 9001 |
| victim-samba | 172.20.0.104 | Samba 4.6.3 (CVE-2017-7494), 445, 6699 |
| victim-jenkins | 172.20.0.105 | Jenkins 2.441, 8080, 50000, 5005 |
| victim-juice-shop | 172.20.0.106 | OWASP Juice Shop, 3000 |
| victim-postgres | 172.20.0.108 | PostgreSQL 14, 5432 |
| suricata | network_mode: host | IDS/IPS, трафик сети `br-lab` через NFQUEUE 2 |
| evebox | 5636 → хост | веб-интерфейс событий |

Правила: `suricata/rules/lab3.rules` (46 правил по CVE сервисов) и `suricata/rules/lab4/a01.rules … a10.rules` (56 правил по категориям OWASP Top 10 2021).

## Запуск

```bash
docker compose up -d --build
sudo ./add-iptables-rules.sh          # направить трафик br-lab в NFQUEUE 2
docker restart suricata               # применить правила
```

Evebox: <http://localhost:5636>. Логи: `suricata/logs/eve.json`, `suricata/logs/suricata.log`.

## Генерация правил

`suricata/switch_rules.sh` собирает выбранные файлы в `suricata/rules/local.rules` (единственный файл в `rule-files` конфига) и перезапускает контейнер suricata:

```bash
cd suricata
./switch_rules.sh lab3              # только ЛР3
./switch_rules.sh lab4              # все правила ЛР4 (a01…a10)
./switch_rules.sh lab4 a01 a05      # отдельные уязвимости ЛР4
./switch_rules.sh a01 a05           # то же, lab4 подразумевается
./switch_rules.sh all               # ЛР3 + ЛР4
./switch_rules.sh status            # текущий набор
```

`local.rules` в git не хранится (в `.gitignore`).

## Атаки

```bash
docker exec -it attacker bash
cd /home/attacks/<сервис> && ./attack.sh      # activemq, redis, minio, samba, jenkins, postgres
cd /home/attacks/juice-shop/a01 && ./a01.sh   # a01…a10 — по категориям OWASP
```

Samba (CVE-2017-7494) требует python2-эксплойта: на хосте один раз выполнить `./attacks/samba/prepare_by_host.sh`, затем `attack.sh` в контейнере.

## Остановка

```bash
docker compose down
sudo iptables -D FORWARD -i br-lab -o br-lab -j NFQUEUE --queue-num 2
```