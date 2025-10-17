#!/usr/bin/bash
set -e

IMAGE_NAME="everlastingeraser/simple-app:1.0.0"
COMPOSE_FILE="docker-compose.yaml"

echo "Проверка требований..."

if ! command -v docker &> /dev/null; then
  echo "Docker не найден. Пожалуйста, сначала установите Docker"
  exit 1
fi

if ! command -v docker compose &> /dev/null; then
  echo "Docker Compose (v2+) не найден. Пожалуйста, сначала установите Docker Compose (или используйте Docker Desktop)"
  exit 1
fi

echo "Загрузка образа ${IMAGE_NAME}..."
docker pull "${IMAGE_NAME}"

if [ ! -f "$COMPOSE_FILE" ]; then
  echo "Файл 'docker-compose.yaml' не найден в текущей директории: $(pwd)"
  exit 1
fi

echo "Запуск всех сервисов ${COMPOSE_FILE}..."
docker compose -f "${COMPOSE_FILE}" up -d --remove-orphans

echo
echo "Все контейнеры запущены. Текущий статус:"
docker compose ps

echo
echo "Основные эндпойнты:"
echo "  - app:        http://localhost:8080"
echo "  - adminer:    http://localhost:8032"
echo "  - kafka ui:   http://localhost:8082"
echo "  - debezium:   http://localhost:8083"
echo
echo "Чтобы остановить приложение, используйте:  docker compose down"
