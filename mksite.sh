#!/bin/bash
clear

echo "Whats the site name?"
read name
echo "so the site is $name.dev (y|n)?"

makeSite() {
	site="$name.dev"
	echo " "
	echo "Making site..."
	mkdir "/var/www/$site"
	mkdir "/var/www/$site/httpdocs"
	mkdir "/var/www/$site/backups"
	echo "Making Index"
	echo "<?
	echo 'Hello World';
	?>" > "/var/www/$site/httpdocs/index.php"
	


	cd "/var/www/$site/"

	echo "Making Git Repo"
	git init
	
	echo "Changing permissions"
	chown -R kyle "/var/www/$site"
	chmod -R 0755 "/var/www/$site"
	chown -R kyle "/var/www/$site/.git/"	
	
	git add 'httpdocs/index.php'
	git commit -m "initial commit"
	
	echo "Making VHost..."

	cd "/etc/apache2/sites-available"
	echo "<VirtualHost *:80>
	ServerAdmin webmaster@localhost
	ServerName $site
	ServerAlias www.$site
	DocumentRoot /var/www/$site/httpdocs/
	<Directory /var/www/$site/httpdocs/>
		Options Indexes FollowSymLinks MultiViews
		AllowOverride All
		Order allow,deny
		allow from all
	</Directory>

	ScriptAlias /cgi-bin/ /usr/lib/cgi-bin/
	<Directory \"/usr/lib/cgi-bin\">
		AllowOverride All
		Options +ExecCGI -MultiViews +SymLinksIfOwnerMatch
		Order allow,deny
		Allow from all
	</Directory>

	ErrorLog \${APACHE_LOG_DIR}/error.log

	# Possible values include: debug, info, notice, warn, error, crit,
	# alert, emerg.
	LogLevel warn

	CustomLog \${APACHE_LOG_DIR}/access.log combined

    Alias /doc/ \"/usr/share/doc/\"
    <Directory \"/usr/share/doc/\">
        Options Indexes MultiViews FollowSymLinks
        AllowOverride All
        Order deny,allow
        Deny from all
        Allow from 127.0.0.0/255.0.0.0 ::1/128
    </Directory>

</VirtualHost>
" > $site
	echo "Enabling Site..."	
	a2ensite $site
	

	echo "Adding to hosts"
	echo "127.0.0.1 $site www.$site" >> "/etc/hosts"

	echo "Restarting Apache.."
	service apache2 restart

	echo "Creating Database"
	mysqladmin -uroot create $name

	echo "Annnnnd thats a wrap folks"
}

read confirm
if [ $confirm = y ]
	then makeSite;
fi

