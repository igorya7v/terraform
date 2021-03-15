#!/bin/bash
yum -y update
yum -y install httpd

myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`

cat <<EOF > /var/www/html/index.html
<html>
<body bgcolor="black">
<h2><font color="red">Provisioned by Teraform.</font></h2><br><p>
<font color="yellow">Server PrivateIP: <font color="aqua">$myip<br><br>
<font color="blue">
<b>Version 2.0</b>
</body>
</html>
EOF

service httpd start
chkconfig httpd on
