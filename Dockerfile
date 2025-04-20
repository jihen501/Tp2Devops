##Etape 1 : build de proojet 
#  Image de base avec Java
FROM maven:3.8.6-eclipse-temurin-17 AS build

# Répertoire de travail
WORKDIR /app

# compy the pom.xml and download dependencies
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Etape 2 : exécution de l'application
#use a smaller base image to run the application 
FROM openjdk:17-jdk-slim

#set the working directory
WORKDIR /app

#copy the jar file from the build stage to the current stage
COPY --from=build /app/target/*.jar app.jar
## Expose the port the app runs on
EXPOSE 8000

# Commande d'exécution
ENTRYPOINT ["java", "-jar", "app.jar"]
