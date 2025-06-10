#!/bin/bash
set -e

echo ">>> Restarting Tomcat service"
systemctl restart tomcat
echo "Tomcat restarted successfully"
