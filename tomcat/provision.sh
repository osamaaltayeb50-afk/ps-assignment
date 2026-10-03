#!/bin/bash
# provision.sh - installs Java 8 and Apache Tomcat 9, Tomcat listens on 7070
set -e

TOMCAT_VERSION="9.0.98"
TOMCAT_DIR="/opt/tomcat"

export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get install -y openjdk-8-jdk curl

# dedicated user for Tomcat
id tomcat &>/dev/null || useradd -r -m -U -d ${TOMCAT_DIR} -s /bin/false tomcat

# download and unpack Tomcat 9
if [ ! -d "${TOMCAT_DIR}/bin" ]; then
  curl -fsSL "https://archive.apache.org/dist/tomcat/tomcat-9/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz" -o /tmp/tomcat.tar.gz
  mkdir -p ${TOMCAT_DIR}
  tar -xzf /tmp/tomcat.tar.gz -C ${TOMCAT_DIR} --strip-components=1
fi

# change the HTTP connector port from 8080 to 7070
sed -i 's/port="8080"/port="7070"/' ${TOMCAT_DIR}/conf/server.xml

chown -R tomcat:tomcat ${TOMCAT_DIR}
chmod +x ${TOMCAT_DIR}/bin/*.sh

JAVA_HOME_PATH=$(dirname $(dirname $(readlink -f $(which java))))

# systemd service
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

echo "Tomcat is running on port 7070 (host port 9090)"
