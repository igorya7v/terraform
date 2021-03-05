#!/bin/bash
yum -y update
yum -y install httpd
MYIP=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
echo "<h2>WebServer with PrivateIP: $MYIP<h2><br>Provisioned by Terraform <br> Version 1.0" > /var/www/html/index.html
service httpd start
chkconfig httpd on
