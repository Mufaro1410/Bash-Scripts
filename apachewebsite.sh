#!/bin/bash

# variables
URL="https://www.tooplate.com/zip-templates/2134_gotto_job.zip"
ARTNAME="2134_gotto_job"
CONFIG_FILE="$ARTNAME.conf"

# update OS
sudo apt update > /dev/null

# install packages
sudo apt install apache2 wget unzip -y > /dev/null

# download webiste artifact
wget $URL > /dev/null

# unzip the artifact
unzip $ARTNAME.zip > /dev/null

# move unzipped artifact to another directory
mv $ARTNAME /var/www/html

# change ownership and permission for artifact
chown -R www-data:www-data /var/www/html/$ARTNAME
chmod -R 755 /var/www/html/$ARTNAME

# add configuration text to .conf file
cat << EOF >> "$CONFIG_FILE"
	<VirtualHost *:80>
    		ServerAdmin webmaster@localhost
   		ServerName your-domain.com
   		ServerAlias www.your-domain.com
    		DocumentRoot /var/www/html/$ARTNAME
    		<Directory /var/www/html/$ARTNAME>
       		 	Options Indexes FollowSymLinks
        			AllowOverride None
        			Require all granted
    		</Directory>

    		ErrorLog \${APACHE_LOG_DIR}/error.log
    		CustomLog \${APACHE_LOG_DIR}/access.log combined
	</VirtualHost>
EOF

# move .conf file to /etc/apache2/sites-available/
sudo mv $ARTNAME.conf /etc/apache2/sites-available/

# enable new .conf file & disable default.conf file
sudo a2ensite $ARTNAME.conf
sudo a2dissite 000-default.conf

# reload apache2 service
sudo systemctl reload apache2
