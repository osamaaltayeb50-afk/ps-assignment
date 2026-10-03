#!/bin/bash
# setup-tomcat-nginx.sh - Tomcat 9 on port 7070 behind Nginx on port 80 (Ubuntu)
# usage: sudo ./setup-tomcat-nginx.sh
set -e
export DEBIAN_FRONTEND=noninteractive

apt-get update -y
apt-get install -y openjdk-11-jdk nginx curl     # Java 11 is enough for Tomcat 9 on the VM

TOMCAT_VERSION="9.0.98"
TOMCAT_DIR="/opt/tomcat"

id tomcat &>/dev/null || useradd -r -m -U -d ${TOMCAT_DIR} -s /bin/false tomcat
if [ ! -d "${TOMCAT_DIR}/bin" ]; then
  curl -fsSL "https://archive.apache.org/dist/tomcat/tomcat-9/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz" -o /tmp/tomcat.tar.gz
  mkdir -p ${TOMCAT_DIR}
  tar -xzf /tmp/tomcat.tar.gz -C ${TOMCAT_DIR} --strip-components=1
fi

# Tomcat port 8080 -> 7070
sed -i 's/port="8080"/port="7070"/' ${TOMCAT_DIR}/conf/server.xml
chown -R tomcat:tomcat ${TOMCAT_DIR}
chmod +x ${TOMCAT_DIR}/bin/*.sh

JAVA_HOME_PATH=$(dirname $(dirname $(readlink -f $(which java))))
cat > /etc/systemd/system/tomcat.service <<SERVICE
[Unit]
Description=Apache Tomcat 9
After=network.target

[Service]
Type=forking
User=tomcat
Group=tomcat
Environment="JAVA_HOME=${JAVA_HOME_PATH}"
Environment="CATALINA_HOME=${TOMCAT_DIR}"
Environment="CATALINA_PID=${TOMCAT_DIR}/temp/tomcat.pid"
ExecStart=${TOMCAT_DIR}/bin/startup.sh
ExecStop=${TOMCAT_DIR}/bin/shutdown.sh
Restart=on-failure

[Install]
WantedBy=multi-user.target
SERVICE
systemctl daemon-reload
systemctl enable --now tomcat

# Nginx reverse proxy
cp "$(dirname "$0")/nginx-tomcat.conf" /etc/nginx/sites-available/tomcat
ln -sf /etc/nginx/sites-available/tomcat /etc/nginx/sites-enabled/tomcat
rm -f /etc/nginx/sites-enabled/default
nginx -t
systemctl restart nginx

# DNS name for the test: add it to the local hosts file
grep -q "myapp.local" /etc/hosts || echo "127.0.0.1 myapp.local" >> /etc/hosts

echo "Test: curl -I http://myapp.local   (Nginx :80  ->  Tomcat :7070)"
