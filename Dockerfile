FROM tomcat:8.5.47-jdk8-openjdk
COPY target/maven-web-application.war /usr/local/tomcat/webapps/maven-web-application.war
#CMD ["catalina.sh", "run"]