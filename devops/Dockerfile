# Tomcat 9 image with a sample WAR deployed
FROM tomcat:9.0-jdk11-temurin

# remove the default apps and put our WAR as the ROOT application
RUN rm -rf /usr/local/tomcat/webapps/*
COPY sample.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
