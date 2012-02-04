#!/bin/bash
clear

echo "Whats the site name?"
read name
echo "so the site is $name.dev (y|n)?"
read confirm

remSite() {
	site="$name.dev"
	echo "Removing site.."
	rm -r "/var/www/$site"
	a2dissite $site
	rm "/etc/apache2/sites-available/$site"
	mysqladmin -uroot drop $name
	service apache2 restart

	echo "Presto Goneo"
}

if [ $confirm = y ]
	then remSite;
fi
