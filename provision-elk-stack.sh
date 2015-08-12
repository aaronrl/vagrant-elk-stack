#!/bin/bash
# Provision ELK stack

### Oracle Java 8
sudo add-apt-repository -y ppa:webupd8team/java
sudo apt-get update
sudo apt-get -y install oracle-java8-installer


echo "### Install Elasticsearch #######################################################"
wget -O - http://packages.elasticsearch.org/GPG-KEY-elasticsearch | sudo apt-key add -
echo 'deb http://packages.elasticsearch.org/elasticsearch/1.7/debian stable main' | sudo tee /etc/apt/sources.list.d/elasticsearch.list
sudo apt-get update
sudo apt-get -y install elasticsearch

#### configure ES
sudo cp /vagrant-data/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml
#>>> http.cors.enabled: true
#>>> http.cors.allow-origin: "*"
#>>> network.host: localhost

sudo service elasticsearch restart
sudo update-rc.d elasticsearch defaults 95 10

#### install kopf
sudo /usr/share/elasticsearch/bin/plugin -install lmenezes/elasticsearch-kopf

echo "### Install Logstash ############################################################"
sudo apt-get update
sudo apt-get -y install logstash
sudo cp /vagrant-data/logstash.conf /etc/logstash/conf.d/logstash.conf

echo "### Install Kibana ##############################################################"
cd ~; wget https://download.elastic.co/kibana/kibana/kibana-4.1.1-linux-x64.tar.gz
tar xvf kibana-*.tar.gz
sudo cp /vagrant-data/kibana.yml ~/kibana-4*/config/kibana.yml
#>>> host: "localhost"
sudo mkdir -p /opt/kibana
sudo cp -R ~/kibana-4*/* /opt/kibana/
cd /etc/init.d && sudo wget https://gist.githubusercontent.com/thisismitch/8b15ac909aed214ad04a/raw/bce61d85643c2dcdfbc2728c55a41dab444dca20/kibana4
sudo chmod +x /etc/init.d/kibana4
sudo update-rc.d kibana4 defaults 96 9
sudo service kibana4 start
