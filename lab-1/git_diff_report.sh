#!/usr/bin/bash

if [ "$#" -ne 3 ]; then
	echo "Использование: $0 <REPO_URL> <BRANCH1> <BRANCH2>"
	exit 1
fi

REPO_URL="$1"
BRANCH1="$2"
BRANCH2="$3"

WORK_DIR=$(pwd)

TMP_DIR=$(mktemp -d)
REPORT_FILE="diff_report_${BRANCH1}_vs_${BRANCH2}.txt"

git clone --quiet "$REPO_URL" "$TMP_DIR" || { echo "Ошибка: не удалось клонировать репозиторий"; exit 1; }

cd "$TMP_DIR" || exit 1

git fetch origin "$BRANCH1" "$BRANCH2" --quiet
if ! git rev-parse --verify "origin/$BRANCH1" >/dev/null 2>&1; then
    echo "Ошибка: ветка $BRANCH1 не найдена"
    exit 1
fi
if ! git rev-parse --verify "origin/$BRANCH2" >/dev/null 2>&1; then
    echo "Ошибка: ветка $BRANCH2 не найдена"
    exit 1
fi

DIFF=$(git diff --name-status "origin/$BRANCH1" "origin/$BRANCH2")

ADDED=$(echo "$DIFF" | grep -c "^A" || true)
DELETED=$(echo "$DIFF" | grep -c "^D" || true)
MODIFIED=$(echo "$DIFF" | grep -c "^M" || true)
TOTAL=$(echo "$DIFF" | grep -E "^[ADM]" | wc -l | tr -d ' ')

{
    echo "Отчет о различиях между ветками"
    echo
    echo "================================"
    echo "Репозиторий:    $REPO_URL"
    echo "Ветка 1:        $BRANCH1"
    echo "Ветка 2:        $BRANCH2"
    echo "Дата генерации: $(date '+%Y-%m-%d %H:%M:%S')"
    echo "================================"
    echo
    echo "СПИСОК ИЗМЕНЕННЫХ ФАЙЛОВ:"
    echo "$DIFF"
    echo
    echo "СТАТИСТИКА:"
    echo "Всего измененных файлов: $TOTAL"
    echo "Добавлено (A):           $ADDED"
    echo "Удалено (D):             $DELETED"
    echo "Изменено (M):            $MODIFIED"
} > "$WORK_DIR/$REPORT_FILE"

cd ..
mv "$REPORT_FILE" "$(pwd)/$REPORT_FILE"

rm -rf "$TMP_DIR"

echo "Отчет успешно создан: $REPORT_FILE"
