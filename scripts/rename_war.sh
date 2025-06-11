#!/bin/bash
set -e
echo ">>> Renaming HelloWorld-0.0.1-SNAPSHOT.war to ROOT.war"
mv /opt/tomcat/webapps/HelloWorld-0.0.1-SNAPSHOT.war /opt/tomcat/webapps/ROOT.war
