#!/bin/bash
set -e

WAR_NAME=HelloWorld-0.0.1-SNAPSHOT.war

echo ">>> Stopping Tomcat before deploying WAR"
systemctl stop tomcat

echo ">>> Deploying WAR to /opt/tomcat/webapps/"
cp /opt/codedeploy-agent/deployment-root/*/deployment-archive/target/$WAR_NAME /opt/tomcat/webapps/
chown tomcat:tomcat /opt/tomcat/webapps/$WAR_NAME

echo ">>> WAR deployed successfully"
