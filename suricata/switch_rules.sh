# Переключение наборов правил Suricata: ./switch-rules.sh lab3|lab4|all|status
# local.rules собирается из rules/lab3.rules (ЛР3) и rules/lab4.rules (ЛР4)
set -e
cd "$(dirname "$0")/rules"

case "$1" in
    lab3) SETS="lab3" ;;
    lab4) SETS="lab4" ;;
    all)  SETS="lab3 lab4" ;;
    status) grep '^# Набор:' local.rules 2>/dev/null || echo "local.rules отсутствует"; exit 0 ;;
    *) echo "Использование: $0 lab3|lab4|all|status"; exit 1 ;;
esac

{
    echo "# Набор: $SETS"
    for s in $SETS; do
        echo
        cat "$s.rules"
    done
} > local.rules

echo "[+] local.rules: $SETS, правил: $(grep -cE '^(alert|drop|reject)' local.rules)"
