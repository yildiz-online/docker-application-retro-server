FROM alpine/git as clone
MAINTAINER Grégory Van den Borre <vandenborre.gregory@hotmail.fr>
ARG GH_TOKEN
WORKDIR /app
RUN git clone https://$GH_TOKEN@github.com/yildiz-online/retro-server.git

FROM moussavdb/build-java-dependencies-arm64 as build
MAINTAINER Grégory Van den Borre <vandenborre.gregory@hotmail.fr>
WORKDIR /app
COPY --from=clone /app/retro-server /app
RUN mvn package -s ../build-resources/settings.xml -DskipTests -Pbuild-assembly

FROM moussavdb/runtime-java-arm64
MAINTAINER Grégory Van den Borre <vandenborre.gregory@hotmail.fr>
EXPOSE 10301
WORKDIR /app
COPY --from=build /app/target/server.jar /app
CMD ["java", "-jar", "server.jar"]
