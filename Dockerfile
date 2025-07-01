# Use an official lightweight JDK image
FROM eclipse-temurin:17-jdk-jammy

# Set working directory
WORKDIR /app

# Copy the JAR file from the Gradle build output
COPY target/*.jar spring-pet-clinic.jar

# Expose the port your app runs on
EXPOSE 8080

# Run the JAR
ENTRYPOINT ["java", "-jar", "spring-pet-clinic.jar"]