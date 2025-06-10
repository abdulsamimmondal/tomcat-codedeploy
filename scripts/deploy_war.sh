#!/bin/bash
set -e

WAR_NAME="HelloWorld-0.0.1-SNAPSHOT.war"
WAR_SOURCE_PATH=$(find /opt/codedeploy-agent/deployment-root/ -type f -name "$WAR_NAME" 2>/dev/null | head -n 1)
WAR_DEST_PATH="/opt/tomcat/webapps/$WAR_NAME"

if [ -z "$WAR_SOURCE_PATH" ]; then
  echo "ERROR: WAR file '$WAR_NAME' not found in CodeDeploy archive."
  exit 1
fi

echo ">>> Stopping Tomcat before deploying WAR"
systemctl stop tomcat

echo ">>> Deploying WAR to /opt/tomcat/webapps/"
cp "$WAR_SOURCE_PATH" "$WAR_DEST_PATH"
chown tomcat:tomcat "$WAR_DEST_PATH"

echo "WAR deployed successfully to $WAR_DEST_PATH"
