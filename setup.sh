#!/bin/bash -x
export JAVA_HOME=/usr/local/java
export HADOOP_PREFIX=/usr/local/hadoop
HADOOP_VERSION=2.5.1 
HADOOP_ARCHIVE=hadoop-${HADOOP_VERSION}.tar.gz   
JAVA_ARCHIVE=jdk-7u51-linux-x64.gz
HADOOP_MIRROR_DOWNLOAD=http://apache.mirror.quintex.com/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz
	
function fileExists {
	FILE=/vagrant/resources/$1
	if [ -e $FILE ]
	then
		return 0
	else
		return 1
	fi
}

function disableFirewall {
	echo "disabling firewall"
	service iptables save
	service iptables stop
	chkconfig iptables off
}

function installLocalJava {
	echo "installing oracle jdk"
	FILE=/vagrant/resources/$JAVA_ARCHIVE
	tar -xzf $FILE -C /usr/local
}

function installRemoteJava {
	echo "install open jdk"
	yum install -y java-1.7.0-openjdk.x86_64
}

function installLocalHadoop {
	echo "install hadoop from local file"
	FILE=/vagrant/resources/$HADOOP_ARCHIVE
	tar -xzf $FILE -C /usr/local
	echo here is hadoop stuff
	ls /usr/local
}

function installRemoteHadoop {
	echo "install hadoop from remote file"
	curl -o /home/vagrant/hadoop-${HADOOP_VERSION}.tar.gz -O -L $HADOOP_MIRROR_DOWNLOAD
	tar -xzf /home/vagrant/hadoop-${HADOOP_VERSION}.tar.gz -C /usr/local
}

function setupJava {
	echo "setting up java"
	if fileExists $JAVA_ARCHIVE; then
		ln -s /usr/local/jdk1.7.0_51 /usr/local/java
	else
		ln -s /usr/lib/jvm/jre /usr/local/java
	fi
}

function setupHadoop {
	echo "creating hadoop directories"
	mkdir /tmp/hadoop-namenode
	mkdir /tmp/hadoop-logs
	mkdir /tmp/hadoop-datanode
	ln -s /usr/local/hadoop-${HADOOP_VERSION} /usr/local/hadoop


	echo "copying over hadoop configuration files"
	cp -f /vagrant/resources/core-site.xml /usr/local/hadoop/etc/hadoop
	cp -f /vagrant/resources/hdfs-site.xml /usr/local/hadoop/etc/hadoop
	cp -f /vagrant/resources/mapred-site.xml /usr/local/hadoop/etc/hadoop
	cp -f /vagrant/resources/yarn-site.xml /usr/local/hadoop/etc/hadoop
	cp -f /vagrant/resources/slaves /usr/local/hadoop/etc/hadoop
	cp -f /vagrant/resources/hadoop-env.sh /usr/local/hadoop/etc/hadoop
	cp -f /vagrant/resources/yarn-env.sh /usr/local/hadoop/etc/hadoop
	cp -f /vagrant/resources/yarn-daemon.sh /usr/local/hadoop/sbin
	cp -f /vagrant/resources/mr-jobhistory-daemon.sh /usr/local/hadoop/sbin
	echo "modifying permissions on local file system"
	chown -fR vagrant /tmp/hadoop-namenode
    chown -fR vagrant /tmp/hadoop-logs
    chown -fR vagrant /tmp/hadoop-datanode
	mkdir /usr/local/hadoop-${HADOOP_VERSION}/logs
	chown -fR vagrant /usr/local/hadoop-${HADOOP_VERSION}/logs
}

function setupEnvVars {
	echo "creating java environment variables"
	#if fileExists $JAVA_ARCHIVE; then
	#	echo export JAVA_HOME=/usr/local/jdk1.7.0_51 >> /etc/profile.d/java.sh
	#else
	#	echo export JAVA_HOME=/usr/lib/jvm/jre >> /etc/profile.d/java.sh
	#fi
	echo export JAVA_HOME=/usr/local/java >> /etc/profile.d/java.sh
	echo export PATH=\${JAVA_HOME}/bin:\${PATH} >> /etc/profile.d/java.sh
	
	echo "creating hadoop environment variables"
	cp -f /vagrant/resources/hadoop.sh /etc/profile.d/hadoop.sh
}

function setupHadoopService {
	echo "setting up hadoop service"
	cp -f /vagrant/resources/hadoop /etc/init.d/hadoop
	chmod 777 /etc/init.d/hadoop
	chkconfig --level 2345 hadoop on
}

function setupNameNode {
	echo "setting up namenode"
	/usr/local/hadoop-${HADOOP_VERSION}/bin/hdfs namenode -format myhadoop
}

function startHadoopService {
	echo "starting hadoop service"
	service hadoop start
}

function installHadoop {
	if fileExists $HADOOP_ARCHIVE; then
		installLocalHadoop
	else
		installRemoteHadoop
	fi
}

function installJava {
	if fileExists $JAVA_ARCHIVE; then
		installLocalJava
	else
		installRemoteJava
	fi
}

function initHdfsTempDir {
	$HADOOP_PREFIX/bin/hdfs --config $HADOOP_PREFIX/etc/hadoop dfs -mkdir /tmp
	$HADOOP_PREFIX/bin/hdfs --config $HADOOP_PREFIX/etc/hadoop dfs -chmod -R 777 /tmp
}

disableFirewall
installJava
installHadoop
setupJava
setupHadoop
setupEnvVars
setupNameNode
setupHadoopService
startHadoopService
initHdfsTempDir
