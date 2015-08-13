#!/bin/bash
# Provision ELK stack

echo "### Add custom package repository listings ##############################"
sudo add-apt-repository ppa:openjdk-r/ppa
wget -O - http://packages.elasticsearch.org/GPG-KEY-elasticsearch | sudo apt-key add -
echo 'deb http://packages.elasticsearch.org/elasticsearch/1.7/debian stable main' | sudo tee /etc/apt/sources.list.d/elasticsearch.list
echo 'deb http://packages.elasticsearch.org/logstash/1.5/debian stable main' | sudo tee /etc/apt/sources.list.d/logstash.list
sudo apt-get update

echo "### Install OpenJDK 8 ###################################################"
sudo apt-get -y install openjdk-8-jdk
java -version

echo "### Install Elasticsearch ###############################################"
sudo apt-get -y install elasticsearch

echo "### Copy default Elasticsearch configuration ############################"
sudo rm -f /etc/elasticsearch/elasticsearch.yml
sudo ln -s /vagrant-data/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml

echo "### Restart Elasticsearch service #######################################"
sudo service elasticsearch restart
sudo update-rc.d elasticsearch defaults 95 10

echo "### Install Elasticsearch-Kopf Management Plugin ########################"
sudo /usr/share/elasticsearch/bin/plugin -install lmenezes/elasticsearch-kopf

echo "### Install Logstash ####################################################"
sudo apt-get -y install logstash

echo "### Copy default Logstash configuration #################################"
sudo rm -f /etc/logstash/conf.d/logstash.conf
sudo ln -s /vagrant-data/logstash.conf /etc/logstash/conf.d/logstash.conf

echo "### Restart Logstash ####################################################"
sudo service logstash restart

echo "### Download Kibana #####################################################"
cd ~; wget -nv https://download.elastic.co/kibana/kibana/kibana-4.1.1-linux-x64.tar.gz
tar xf kibana-*.tar.gz

echo "### Install Kibana ######################################################"
sudo mkdir -p /opt/kibana
sudo cp -R ~/kibana-4*/* /opt/kibana/
cd /etc/init.d && sudo wget -nv https://gist.githubusercontent.com/thisismitch/8b15ac909aed214ad04a/raw/bce61d85643c2dcdfbc2728c55a41dab444dca20/kibana4
sudo chmod +x /etc/init.d/kibana4
sudo update-rc.d kibana4 defaults 96 9

echo "### Copy default Kibana configuration ###################################"
sudo rm -f /opt/kibana/config/kibana.yml
sudo ln -s /vagrant-data/kibana.yml /opt/kibana/config/kibana.yml

echo "### Start Kibana ########################################################"
sudo service kibana4 start
