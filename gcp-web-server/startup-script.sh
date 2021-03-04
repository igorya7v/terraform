#!/bin/bash
sudo apt update -y
sudo apt install apache2 -y
sudo echo "<h2>"WebServer Provisioned by Terraform"<h2>"  >  /var/www/html/index.html
sudo systemctl restart apache2
