#!/usr/bin/env bash

echo ">>> Installing android";

ANDROID_SDK_FILENAME=android-sdk_r23.0.2-linux.tgz
ANDROID_SDK=http://dl.google.com/android/$ANDROID_SDK_FILENAME

# Intall Dependencies (JDK, Ant and expect)
sudo apt-get install -y openjdk-7-jdk ant expect

# Download Android SDK
curl -O $ANDROID_SDK
tar -xzvf $ANDROID_SDK_FILENAME

# Add permissions for vagrant user and removing .tgz file
sudo chown -R vagrant android-sdk-linux/
sudo rm -rf $ANDROID_SDK_FILENAME

# Add new values of variables environment in .bashrc
echo "" >> /home/vagrant/.bashrc
echo "JAVA_HOME=/usr/lib/jvm/java-7-openjdk-i386/jre/bin/java" >> /home/vagrant/.bashrc
echo "ANDROID_HOME=~/android-sdk-linux" >> /home/vagrant/.bashrc
echo "export PATH=\$PATH:~/android-sdk-linux/tools:~/android-sdk-linux/platform-tools" >> /home/vagrant/.bashrc

expect -c '
set timeout -1   ;
spawn /home/vagrant/android-sdk-linux/tools/android update sdk -u --all --filter platform-tool,android-19,build-tools-19.1.0
expect {
    "Do you accept the license" { exp_send "y\r" ; exp_continue }
    eof
}
'

sudo /home/vagrant/android-sdk-linux/platform-tools/adb kill-server
sudo /home/vagrant/android-sdk-linux/platform-tools/adb start-server
sudo /home/vagrant/android-sdk-linux/platform-tools/adb devices
