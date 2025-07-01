# spring-pet-clinic
I set up end-to-end CI/CD pipelines for a Spring Boot application using GitHub Actions and JFrog Artifactory.

1. Project Selection
I used the official spring-petclinic project (https://github.com/spring-projects/spring-petclinic) as the source application. This is a classic Spring Boot sample application demonstrating best practices in Java web development using Spring technologies.

2. CI/CD Pipeline with GitHub Actions
I created two GitHub Actions workflow files to automate the build process using Maven and Gradle. The pipelines include the following stages:

    Code Checkout: Pulls the source code from GitHub.
    Build, Test, Package and Verify: Using Gradle or Maven command (./gradlew build or ./mvnw -B verify).
    Docker Image Build: Builds a container image using "./gradlew bootBuildImage" or "./mvnw spring-boot:build-image" to package the Spring Boot application.
    Image Push: Pushes the built Docker image to a private Docker repository hosted on JFrog Artifactory.

3. JFrog SaaS Trial Setup: I signed up for a free 14-day trial of the JFrog SaaS platform

4. Used GitHub Actions to build the image and push it to my JFrog Docker local repository (aaron-docker-local).

5. Ensured the image was tagged appropriately (<instance>.jfrog.io/<repo>/spring-pet-clinic:<version>).

6. Dependency Management via JFrog
Configured the project to resolve all Maven or Gradle dependencies through the JFrog virtual repositories, verified that dependencies were cached in the remote or virtual repo and not fetched from the public internet.

## Run Spring-Pet-Clinic locally

Spring-Pet-Clinic is a [Spring Boot](https://spring.io/guides/gs/spring-boot) application built using [Maven](https://spring.io/guides/gs/maven/) or [Gradle](https://spring.io/guides/gs/gradle/). You can build a jar file and run it from the command line (it should work just as well with Java 17 or newer):

```bash
git clone https://github.com/cx-aaron-zhou/spring-pet-clinic
cd spring-pet-clinic
./mvnw package
java -jar target/*.jar
```

(On Windows, or if your shell doesn't expand the glob, you might need to specify the JAR file name explicitly on the command line at the end there.)

You can then access the Spring-Pet-Clinic at <http://localhost:8080/>.

<img width="1042" alt="petclinic-screenshot" src="https://cloud.githubusercontent.com/assets/838318/19727082/2aee6d6c-9b8e-11e6-81fe-e889a5ddfded.png">

Or you can run it from Maven directly using the Spring Boot Maven plugin. If you do this, it will pick up changes that you make in the project immediately:

```bash
./mvnw spring-boot:run
```

> NOTE: If you prefer to use Gradle, you can build the app using `./gradlew build` and look for the jar file in `build/libs`.

## Building a Container

There is a `Dockerfile` in this project. You can build a container image if you have a docker or podman daemon:

```bash
podman build -t spring-pet-clinic:latest .
podman run -d -p 8080:8080 --name spring-pet-clinic spring-pet-clinic:latest
```

Otherwise, you could use the Spring Boot build plugin:

```bash
./mvnw spring-boot:build-image
```

or,

```bash
./gradlew bootBuildImage
```

## Database configuration

In its default configuration, spring-pet-clinic uses an in-memory database (H2) which
gets populated at startup with data. The h2 console is exposed at `http://localhost:8080/h2-console`,
and it is possible to inspect the content of the database using the `jdbc:h2:mem:<uuid>` URL. The UUID is printed at startup to the console.

A similar setup is provided for MySQL and PostgreSQL if a persistent database configuration is needed. Note that whenever the database type changes, the app needs to run with a different profile: `spring.profiles.active=mysql` for MySQL or `spring.profiles.active=postgres` for PostgreSQL. See the [Spring Boot documentation](https://docs.spring.io/spring-boot/how-to/properties-and-configuration.html#howto.properties-and-configuration.set-active-spring-profiles) for more detail on how to set the active profile.

You can start MySQL or PostgreSQL locally with whatever installer works for your OS or use docker:

```bash
docker run -e MYSQL_USER=petclinic -e MYSQL_PASSWORD=petclinic -e MYSQL_ROOT_PASSWORD=root -e MYSQL_DATABASE=petclinic -p 3306:3306 mysql:9.2
```

or

```bash
docker run -e POSTGRES_USER=petclinic -e POSTGRES_PASSWORD=petclinic -e POSTGRES_DB=petclinic -p 5432:5432 postgres:17.5
```

Further documentation is provided for [MySQL](https://github.com/spring-projects/spring-petclinic/blob/main/src/main/resources/db/mysql/petclinic_db_setup_mysql.txt)
and [PostgreSQL](https://github.com/spring-projects/spring-petclinic/blob/main/src/main/resources/db/postgres/petclinic_db_setup_postgres.txt).

Instead of vanilla `docker` you can also use the provided `docker-compose.yml` file to start the database containers. Each one has a service named after the Spring profile:

```bash
docker compose up mysql
```

or

```bash
docker compose up postgres
```
