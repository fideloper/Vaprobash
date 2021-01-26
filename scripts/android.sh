#!/usr/bin/env bash

echo ">>> Installing android";

ANDROID_SDK_FILENAME=android-sdk_r23.0.2-linux.tgz
ANDROID_SDK=http://dl.google.com/android/$ANDROID_SDK_FILENAME

# Intall Dependencies (JDK, Ant and expect)
sudo apt-get install -y openjdk-7-jdk ant expect

# Download Android SDK
curl -O $ANDROID_SDK
tar -xzvf $ANDROID_SDK_FILENAME

# Add permissions for ubuntu user and removing .tgz file
sudo chown -R ubuntu android-sdk-linux/
sudo rm -rf $ANDROID_SDK_FILENAME

# Add new values of variables environment in .bashrc
echo "" >> /home/ubuntu/.bashrc
echo "JAVA_HOME=/usr/lib/jvm/java-7-openjdk-i386/jre/bin/java" >> /home/ubuntu/.bashrc
echo "ANDROID_HOME=~/android-sdk-linux" >> /home/ubuntu/.bashrc
echo "export PATH=\$PATH:~/android-sdk-linux/tools:~/android-sdk-linux/platform-tools" >> /home/ubuntu/.bashrc

expect -c '
set timeout -1   ;
spawn /home/ubuntu/android-sdk-linux/tools/android update sdk -u --all --filter platform-tool,android-19,build-tools-19.1.0
expect {
    "Do you accept the license" { exp_send "y\r" ; exp_continue }
    eof
}
'

sudo /home/ubuntu/android-sdk-linux/platform-tools/adb kill-server
sudo /home/ubuntu/android-sdk-linux/platform-tools/adb start-server
sudo /home/ubuntu/android-sdk-linux/platform-tools/adb devices

sudo apt -f -y autoremove --purge