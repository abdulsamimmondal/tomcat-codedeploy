# Use the official Tomcat base image
FROM tomcat:9.0-jdk11

# Remove the default web applications from Tomcat
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy your WAR file into Tomcat's webapps directory
COPY target/HelloWorld-0.0.1-SNAPSHOT.war /usr/local/tomcat/webapps/ROOT.war

# Expose port 8080 to access the application
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
