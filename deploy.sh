#! /bin/bash

#Builds the image passing VERSION as parameter

docker build --build-arg VERSION=${VERSION}.jar --tag medraut/spring-app:${VERSION} .

#Logs in into docker hub

docker login -u ${DUSER} -p ${DPASSWORD}

#push new container image to docker hub

docker push medraut/spring-app:${VERSION}
