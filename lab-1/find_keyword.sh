#!/usr/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Использование: $0 <LOGFILE> <KEYWORD>"
    exit 1
fi

LOGFILE="$1"
KEYWORD="$2"

if [ ! -f "$LOGFILE" ]; then
    echo "Ошибка: файл '$LOGFILE' не найден"
    exit 1
fi

BASENAME=$(basename "$LOGFILE")

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

OUTPUT_ERRORS="${BASENAME}_${TIMESTAMP}_filtered.txt"
OUTPUT_COUNT="${BASENAME}_${TIMESTAMP}_count.txt"

grep "$KEYWORD" "$LOGFILE" > "$OUTPUT_ERRORS"

COUNT=$(grep -c "$KEYWORD" "$LOGFILE")

echo "Количество строк, содержащих '$KEYWORD': $COUNT" > "$OUTPUT_COUNT"

echo "Найдено $COUNT строк с ключевым словом '$KEYWORD'"
echo "Результаты сохранены в:"
echo " - $OUTPUT_ERRORS (список найденных строк)"
echo " - $OUTPUT_COUNT (количество найденных строк)"
