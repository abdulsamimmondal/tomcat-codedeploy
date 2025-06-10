#!/bin/bash
set -e

echo ">>> Starting Tomcat service"
systemctl start tomcat
echo ">>> Tomcat started successfully"
