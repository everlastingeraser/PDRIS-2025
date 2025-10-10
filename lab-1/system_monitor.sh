#!/usr/bin/bash

PID_FILE="/tmp/system_monitor.pid"
INTERVAL=600  # 10 min

get_metrics() {
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')

    mem_total=$(free -m | awk '/Mem:/ {print $2}')
    mem_free=$(free -m | awk '/Mem:/ {print $7}')
    mem_used_percent=$(free | awk '/Mem:/ {printf("%.2f", $3/$2*100)}')

    cpu_used_percent=$(top -bn1 | awk '/Cpu\(s\)/ {print 100 - $8}')

    disk_used_percent=$(df / | awk 'END{print $5}' | tr -d '%')

    load_avg_1m=$(uptime | awk -F'load average:' '{print $2}' | cut -d',' -f1 | tr -d ' ')

    log_file="./system_report_$(date '+%Y-%m-%d').csv"

	# header
    if [ ! -f "$log_file" ]; then
        echo "timestamp;all_memory;free_memory;%memory_used;%cpu_used;%disk_used;load_average_1m" > "$log_file"
    fi

    echo "$timestamp;$mem_total;$mem_free;$mem_used_percent;$cpu_used_percent;$disk_used_percent;$load_avg_1m" >> "$log_file"
}

start_monitor() {
    if [ -f "$PID_FILE" ] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
        echo "Скрипт уже запущен (PID=$(cat "$PID_FILE"))"
        exit 1
    fi

    echo "Запускаем мониторинг в фоне..."
    (
        while true; do
            get_metrics
            sleep "$INTERVAL"
        done
    ) &
    echo $! > "$PID_FILE"
    echo "Мониторинг запущен. PID=$(cat "$PID_FILE")"
}

stop_monitor() {
    if [ ! -f "$PID_FILE" ]; then
        echo "PID файл не найден. Пожалуйста, сначала запустите мониторинг"
        exit 1
    fi

    pid=$(cat "$PID_FILE")
    if kill -0 "$pid" 2>/dev/null; then
        kill "$pid"
        rm -f "$PID_FILE"
        echo "Процесс $pid остановлен"
    else
        echo "Процесс $pid не найден. Удаляю PID файл..."
        rm -f "$PID_FILE"
    fi
}

status_monitor() {
    if [ -f "$PID_FILE" ]; then
        pid=$(cat "$PID_FILE")
        if kill -0 "$pid" 2>/dev/null; then
            echo "Мониторинг запущен (PID=$pid)"
            exit 0
        else
            echo "PID файл был найден, но процесс не запущен"
            exit 1
        fi
    else
        echo "Мониторинг не запущен"
    fi
}

case "$1" in
    START)
        start_monitor
        ;;
    STOP)
        stop_monitor
        ;;
    STATUS)
        status_monitor
        ;;
    *)
        echo "Использование: $0 {START|STOP|STATUS}"
        exit 1
        ;;
esac
