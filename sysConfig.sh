
#
# Config a fresh installed (Debian based) system

# TODO Insert script to delete open jdk

# Install java from webupd8team
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update
sudo apt-get install oracle-java8-installer

## TODO: Write bash code to execute this task
## Also ensure your JAVA_HOME variable has been set in '/etc/environment':
## JAVA_HOME=/usr/lib/jvm/java-8-oracle


##
## NodeJS (V6) install
sudo apt-get install curl
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
sudo apt-get install -y nodejs
