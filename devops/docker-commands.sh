#!/bin/bash
# docker-commands.sh - commands used for the Docker part (replace YOUR_DOCKERHUB_USER)
DH_USER="YOUR_DOCKERHUB_USER"

# 1) build the Tomcat image with the sample WAR
docker build -t $DH_USER/tomcat-sample:1.0 .

# 2) test it locally
docker run -d --name tomcat-sample -p 8081:8080 $DH_USER/tomcat-sample:1.0
curl -I http://localhost:8081

# 3) push it to Docker Hub (docker login asks for the password - type it yourself)
docker login -u $DH_USER
docker push $DH_USER/tomcat-sample:1.0

# 4) Nginx and PostgreSQL as containers
docker run -d --name my-nginx -p 8082:80 nginx:stable
docker run -d --name my-postgres -e POSTGRES_PASSWORD='CHOOSE_A_PASSWORD' -e POSTGRES_DB=psdb \
           -v pgdata:/var/lib/postgresql/data -p 5432:5432 postgres:16

# 5) check
docker ps
