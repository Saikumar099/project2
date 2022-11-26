FROM tomcat:8.0.20-jre8
COPY target/maven-web-app*.war /usr/local/tomcat/webapps/maven-web-application.war
CMD ["catalina.sh", "run"]
#ENV RUN_USER            tomcat
#ENV RUN_GROUP           tomcat

# Add a tomcat user
#RUN groupadd -r ${RUN_GROUP} && useradd -g ${RUN_GROUP} -d ${CATALINA_HOME} -s /bin/bash ${RUN_USER}
#RUN chown -R tomcat:tomcat $CATALINA_HOME
#RUN ls -lah $CATALINA_HOME
#RUN su -c 'touch $CATALINA_HOME/include/this.still.works' tomcat
#RUN su -c 'touch $CATALINA_HOME/work/this.will.fail' tomcat