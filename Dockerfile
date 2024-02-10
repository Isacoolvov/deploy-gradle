# Используем за основу образ Ubuntu 18.04
FROM ubuntu:18.04

# Обновляем список пакетов и устанавливаем необходимые инструменты
RUN apt-get update && \
    apt-get install -y openjdk-8-jdk git wget unzip && \
    rm -rf /var/lib/apt/lists/*

# Клонируем репозиторий с проектом
WORKDIR /app
RUN git clone https://github.com/jusan-singularity/gradle-spring-rest.git .
#RUN sed -i 's/server.port=8181/server.port=80/' /app/src/main/resources/application.properties

# Устанавливаем Gradle
ENV GRADLE_VERSION=3.5-rc-2
RUN wget https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip -P /tmp && \
    unzip -d /opt/gradle /tmp/gradle-${GRADLE_VERSION}-bin.zip && \
    rm -rf /tmp/*

# Устанавливаем переменную окружения для Gradle
ENV PATH="${PATH}:/opt/gradle/gradle-${GRADLE_VERSION}/bin"

# Добавляем права на выполнение для gradlew
RUN chmod +x ./gradlew

# Собираем проект с помощью Gradle
RUN ./gradlew build --no-daemon

# Экспонируем порт 80
#EXPOSE 80

# Запускаем проект при запуске контейнера
CMD ["java", "-jar", "/app/build/libs/spring-boot-gradle-example-1.0.0.jar"]
