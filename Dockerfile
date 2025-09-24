# Use Tomcat base image
FROM tomcat:9.0.109-jdk17

# Remove default ROOT
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy your WAR file to Tomcat webapps
COPY target/HospitalManagementSysteme.war /usr/local/tomcat/webapps/ROOT.war

# Expose Tomcat port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
