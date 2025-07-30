FROM alpine/git as clone
MAINTAINER Grégory Van den Borre <vandenborre.gregory@hotmail.fr>
ARG GH_TOKEN
WORKDIR /app
RUN git clone https://$GH_TOKEN@github.com/yildiz-online/retro-server.git

FROM moussavdb/build-java:sts as build
MAINTAINER Grégory Van den Borre <vandenborre.gregory@hotmail.fr>
WORKDIR /app
COPY --from=clone /app/retro-server /app
RUN mvn package spring-boot:repackage -DskipTests -s settings.xml

FROM moussavdb/runtime-java:lts
MAINTAINER Grégory Van den Borre <vandenborre.gregory@hotmail.fr>
EXPOSE 8080
WORKDIR /app
COPY --from=build /app/target/server.jar /app
CMD ["java", "-jar", "server.jar"]
