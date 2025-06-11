#!/bin/bash
set -e
echo ">>> Renaming awspipelinedemo.war to ROOT.war"
mv /opt/tomcat/webapps/awspipelinedemo.war /opt/tomcat/webapps/ROOT.war
