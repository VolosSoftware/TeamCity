#!/bin/bash

cd /

# install server dependencies
sudo apt-get update
sudo apt-get install -y openjdk-7-jre-headless
sudo apt-get install -y curl

# install build agent dependencies
sudo apt-get install -y git

# install team city
sudo wget -c https://download.jetbrains.com/teamcity/TeamCity-9.1.1.tar.gz -O /tmp/TeamCity-9.1.1.tar.gz
sudo tar -xvf /tmp/TeamCity-9.1.1.tar.gz -C /srv
sudo rm -rf /tmp/TeamCity-9.1.1.tar.gz
sudo mkdir /srv/.BuildServer

# create user
sudo useradd -m teamcity
sudo chown -R teamcity /srv/TeamCity
sudo chown -R teamcity /srv/.BuildServer

# create init.d script
sudo cp /tmp/TeamCityPackage/teamcity-init.sh /etc/init.d/teamcity
sudo chmod 775 /etc/init.d/teamcity
sudo update-rc.d teamcity defaults

# download postgres
sudo mkdir -p /srv/.BuildServer/lib/jdbc
sudo mkdir -p /srv/.BuildServer/config
sudo wget https://jdbc.postgresql.org/download/postgresql-9.4-1201.jdbc4.jar -O /srv/.BuildServer/lib/jdbc/postgresql-9.4-1201.jdbc4.jar
sudo cp /tmp/TeamCityPackage/postgres.database.properties /srv/.BuildServer/config/database.properties

# ensure owership
sudo chown -R teamcity /srv/TeamCity
sudo chown -R teamcity /srv/.BuildServer