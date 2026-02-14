# -------- Stage 1: Build the app --------
FROM gradle:8.5-jdk17 AS build
WORKDIR /jenkins-test

# Copy Gradle files first (for better caching)
COPY build.gradle settings.gradle gradlew ./
COPY gradle gradle

# Download dependencies
RUN ./gradlew dependencies --no-daemon

# Copy source code
COPY src src

# Build the jar
RUN ./gradlew clean build -x test --no-daemon

# -------- Stage 2: Run the app --------
FROM eclipse-temurin:17-jre
WORKDIR /jenkins-test

# Copy jar from build stage
COPY --from=build /jenkins-test/build/libs/*.jar jenkins-test.jar

# Expose Spring Boot port
EXPOSE 8081

# Run the application
ENTRYPOINT ["java", "-jar", "jenkins-test.jar"]