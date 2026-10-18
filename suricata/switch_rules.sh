# Переключение наборов правил Suricata:
#   ./switch_rules.sh lab3             — правила ЛР3
#   ./switch_rules.sh lab4             — все правила ЛР4 (lab4/a01..a10)
#   ./switch_rules.sh lab4 a01 a05     — правила конкретных уязвимостей ЛР4
#   ./switch_rules.sh a01 a05          — то же (lab4 подразумевается)
#   ./switch_rules.sh all              — ЛР3 + ЛР4
#   ./switch_rules.sh status           — текущий набор
set -e
cd "$(dirname "$0")/rules"

gen() {
    {
        echo "# Набор: $*"
        for f in "$@"; do
            echo
            cat "$f"
        done
    } > local.rules
    echo "[+] local.rules: $*, правил: $(grep -cE '^(alert|drop|reject)' local.rules)"
    if docker ps --format '{{.Names}}' 2>/dev/null | grep -qx suricata; then
        docker restart suricata >/dev/null
        echo "[*] suricata перезапущен"
    else
        echo "[!] контейнер suricata не запущен — после старта: docker restart suricata"
    fi
}

lab4_files() {
    for a in "$@"; do
        [ -f "lab4/$a.rules" ] || { echo "[!] не найдено: lab4/$a.rules" >&2; exit 1; }
        echo "lab4/$a.rules"
    done
}

case "$1" in
    status)
        grep '^# Набор:' local.rules 2>/dev/null || echo "local.rules отсутствует" ;;
    lab3)
        gen lab3.rules ;;
    lab4)
        shift
        if [ "$#" -gt 0 ]; then
            files=$(lab4_files "$@")
            gen $files
        else
            gen lab4/a??.rules
        fi ;;
    all)
        gen lab3.rules lab4/a??.rules ;;
    a??)
        files=$(lab4_files "$@")
        gen $files ;;
    *)
        echo "Использование: $0 lab3|lab4 [a01..a10]|all|status"
        exit 1 ;;
esac
