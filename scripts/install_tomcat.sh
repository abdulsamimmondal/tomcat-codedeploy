#!/bin/bash
set -e

echo ">>> Installing Java and Tomcat 10.1.42"

# Install Java (OpenJDK 11+ is required for Tomcat 10)
apt-get update -y
apt-get install -y default-jdk curl

# Create tomcat user if not exists
id -u tomcat &>/dev/null || useradd -r -m -U -d /opt/tomcat -s /bin/false tomcat

# Download and extract Tomcat 10.1.42
TOMCAT_VERSION=10.1.42
cd /tmp
curl -O https://dlcdn.apache.org/tomcat/tomcat-10/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz

mkdir -p /opt/tomcat
tar -xzf apache-tomcat-${TOMCAT_VERSION}.tar.gz -C /opt/tomcat --strip-components=1

# Set ownership and permissions
chown -R tomcat:tomcat /opt/tomcat
chmod +x /opt/tomcat/bin/*.sh

# Create systemd service file for Tomcat
cat <<EOF > /etc/systemd/system/tomcat.service
[Unit]
Description=Apache Tomcat 10 Web Application Container
After=network.target

[Service]
Type=forking
User=tomcat
Group=tomcat
Environment="JAVA_HOME=$(dirname $(dirname $(readlink -f $(which java))))"
Environment="CATALINA_HOME=/opt/tomcat"
Environment="CATALINA_PID=/opt/tomcat/temp/tomcat.pid"
ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh
SuccessExitStatus=143
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

# Reload and start Tomcat
systemctl daemon-reload
systemctl enable tomcat
systemctl start tomcat

# Open port 8080 if UFW is active
if command -v ufw &>/dev/null && ufw status | grep -q active; then
    ufw allow 8080/tcp
fi

echo ">>> Tomcat 10 installed and started"
