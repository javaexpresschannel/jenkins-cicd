FROM openjdk:17

WORKDIR /app 

COPY ./target/user-service.jar /app

EXPOSE 8085

CMD ["java","-jar","user-service.jar"]
