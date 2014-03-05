# Introduction

This Vagrant project creates a VM with single node setup of Hadoop v2.3.0 with YARN installed.

# Getting Started

1. [Download and install VirtualBox](https://www.virtualbox.org/wiki/Downloads)
2. [Download and install Vagrant](http://www.vagrantup.com/downloads.html).
3. Run ```vagrant box add centos65 https://github.com/2creatives/vagrant-centos/releases/download/v6.5.1/centos65-x86_64-20131205.box```
4. Git clone this project, and change directory (cd) into this project (directory).
5. Run ```vagrant up``` to create the VM.
6. Run ```vagrant ssh``` to get into your VM.
7. Run ```vagrant destroy``` when you want to destroy and get rid of the VM.

Some gotcha's.

1. Make sure you download Vagrant v1.4.3 or higher.
2. Make sure when you clone this project, you preserve the Unix/OSX end-of-line (EOL) characters. The scripts will fail with Windows EOL characters.
3. Make sure you have 8Gb of free memory for the VM. You may change the Vagrantfile to specify smaller memory requirements.
4. This project has NOT been tested with the VMWare provider for Vagrant.
5. You may change the script (setup.sh) to point to a different location for Hadoop to be downloaded from. Here is a list of mirrors: http://www.apache.org/dyn/closer.cgi/hadoop/common/.

# Web UI
You can check the following URLs to monitor the Hadoop daemons.

1. [NameNode] (http://localhost:50070/dfshealth.html)
2. [DataNode] (http://localhost:50075/dataNodeHome.jsp)
3. [ResourceManager] (http://localhost:8088/cluster)
4. [NodeManager] (http://localhost:8042/node)
5. [JobHistory] (http://localhost:19888/jobhistory)

Note that you point your browser to "localhost" because when the VM is created, it is specified to perform port forwarding from your desktop to the VM.

# Vagrant boxes
A list of available Vagrant boxes is shown at http://www.vagrantbox.es. 

# Vagrant box location
The Vagrant box is downloaded to the ~/.vagrant.d/boxes directory. On Windows, this is C:\Users\{your-username}\.vagrant.d\boxes.

# References
This project was kludge together with great pointers from all around the internet. 

1. http://hadoop.apache.org/docs/r2.3.0/hadoop-project-dist/hadoop-common/ClusterSetup.html 
2. http://wiki.apache.org/hadoop/BindException
3. https://www.centos.org/docs/5/html/5.1/Deployment_Guide/s1-server-ports.html
4. http://www.cyberciti.biz/faq/disable-linux-firewall-under-centos-rhel-fedora/ 
5. http://www.cloudera.com/content/cloudera-content/cloudera-docs/CDH4/4.2.0/CDH4-Installation-Guide/cdh4ig_topic_11_2.html 
6. http://blog.cloudera.com/blog/2009/08/hadoop-default-ports-quick-reference/ 
7. http://linuxgalaxy.com/make-life-easier-create-a-service-on-linux/ 
8. http://codingrecipes.com/service-x-does-not-support-chkconfig 
9. http://linux.about.com/library/cmd/blcmdl8_chkconfig.htm 
10. http://stackoverflow.com/questions/20901442/how-to-install-jdk-in-centos 
11. http://serverfault.com/questions/119869/turning-off-cp-copy-commands-interactive-mode-cp-overwrite 
12. http://askubuntu.com/questions/45349/how-to-extract-files-to-another-directory-using-tar-command 

# Copyright Stuff
Copyright 2014 Jee Vang

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
