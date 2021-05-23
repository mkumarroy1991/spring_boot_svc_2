# Pull base image 
From tomcat:8-jre8 

# Maintainer 
MAINTAINER "VinayLodhi" 
COPY ./webapp.war /usr/local/tomcat/webapps

