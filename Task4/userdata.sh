#!/bin/bash -v
apt-get update -y
apt-get install -y nginx > /tmp/nginx.log

service nginx start

echo "user www-data;
worker_processes 4;
pid /run/nginx.pid;
events {
    worker_connections  1024;
}
http {
    upstream backend {
        server localhost:3000;
    }
    server {
        listen 80;
        location / {
            proxy_pass http://127.0.0.1:8080/;
        }
    }
}" > /etc/nginx/nginx.conf

service nginx restart

apt-get install default-jdk -y

apt-get install tomcat8 -y

apt-get install tomcat8-docs tomcat8-examples tomcat8-admin -y

mv /var/lib/tomcat8/webapps/ROOT /tmp/

cd /var/lib/tomcat8/webapps/

wget https://tomcat.apache.org/tomcat-9.0-doc/appdev/sample/sample.war

mv sample.war ROOT.war

service tomcat8 restart
