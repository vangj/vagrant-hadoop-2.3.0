#!/bin/bash
echo "install java"
yum install -y java-1.7.0-openjdk.x86_64

echo "turning off firewall"
service iptables save
service iptables stop
chkconfig iptables off

echo "creating directories for hadoop"
mkdir /tmp/hadoop-namenode
mkdir /tmp/hadoop-logs
mkdir /tmp/hadoop-datanode

echo "downloading hadoop"
curl -o /home/vagrant/hadoop-2.3.0.tar.gz -O -L http://apache.mirror.quintex.com/hadoop/common/hadoop-2.3.0/hadoop-2.3.0.tar.gz

echo "unarchiving hadoop"
tar -xzf /home/vagrant/hadoop-2.3.0.tar.gz -C /usr/local
ln -s /usr/local/hadoop-2.3.0 /usr/local/hadoop
chown -fR vagrant /usr/local/hadoop
chown -fR vagrant /tmp/hadoop-namenode
chown -fR vagrant /tmp/hadoop-logs
chown -fR vagrant /tmp/hadoop-datanode

echo "copying over configuration files"
cp -f /vagrant/resources/java.sh /etc/profile.d/java.sh
cp -f /vagrant/resources/hadoop.sh /etc/profile.d/hadoop.sh
cp -f /vagrant/resources/core-site.xml /usr/local/hadoop/etc/hadoop
cp -f /vagrant/resources/hdfs-site.xml /usr/local/hadoop/etc/hadoop
cp -f /vagrant/resources/slaves /usr/local/hadoop/etc/hadoop
cp -f /vagrant/resources/hadoop /etc/init.d/hadoop

echo "creating hadoop service"
chmod 777 /etc/init.d/hadoop
chkconfig --level 2345 hadoop on

echo "formatting namenode"
sudo -u vagrant -i /vagrant/format-namenode.sh

echo "starting hadoop services"
service hadoop start