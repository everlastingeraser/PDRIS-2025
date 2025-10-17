### Запуск приложения
1. Дождаться запуска контейнера debezium.
2. Загрузить конфигурацию debezium через curl:
   ```shell
    curl -i -X POST -H "Accept:application/json" -H  "Content-Type:application/json" http://localhost:8083/connectors/ -d @debezium/jdbc-sink.json

    curl -i -X POST -H "Accept:application/json" -H  "Content-Type:application/json" http://localhost:8083/connectors/ -d @debezium/source.json
    ```
   ![debezium-config.png](imgs/debezium-config.png)
3. Отправить запрос по эндпойнту `localhost:8080/api/v1/customers`:
    ![http-request.png](imgs/http-request.png)
4. Зайти в adminer `localhost:8032` и проверить наличие записи в таблице `customers`:
    ```
    source-db:5432
    postgres
    postgres
    postgres
    ```
    ![customers-source.png](imgs/customers-source.png)
5. Зайти в kafka-ui `localhost:8082` и проверить наличие автоматически сгенерированного debezium сообщения в топике `customers`:
    ![kafka.png](imgs/kafka.png)
6. Зайти в adminer `localhost:8032` и проверить успешную репликацию записи в таблицу `customers`:
    ```
    sink-db:5432
    postgres
    postgres
    postgres
    ```
   ![customers-sink.png](imgs/customers-sink.png)
