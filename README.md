# CX JVM Tools

Docker Images that contains all major tools and SDK to build JVM Based Languages.

### Including
- ZULU OpenJDK 11 or 8
- Gradle 5.2.1
- Kotlin 1.3.21
- Maven 3.6.0
- KScript 2.7.1
- SBT 1.2.8
- Leiningen latest

## Version
- jasoet/cx-jvm:latest jasoet/cx-jvm:11
- jasoet/cx-jvm:8

### Usage
- This docker image SHOULD NOT be used as base Image for your service/app. 
- This should be used as Docker Image for your gitlab-ci or Circle-Ci. 
- This should be used as container for your compile/build stage on your docker [multistage build](https://docs.docker.com/develop/develop-images/multistage-build/) 

### Maintainer
- Deny Prasetyo 


 
