FROM openjdk:21

RUN groupadd --system --gid 1000 appgroup && \
    useradd --system --uid 1000 --gid appgroup appuser

WORKDIR /app
RUN chown appuser:appgroup /app

COPY --chown=appuser:appgroup target/*.jar app.jar

USER appuser

EXPOSE 8080

ENTRYPOINT ["java","-jar","app.jar"]
