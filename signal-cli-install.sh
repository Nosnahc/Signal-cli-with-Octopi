#!/bin/bash

# set version of signal-cli here
export VERSION=0.11.11

set -euxo pipefail

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root or with sudo rights" 1>&2
   exit 1
fi

# default install
if [ -d "/opt/signal-cli-${VERSION}" ]
then
    echo "signal-cli is alerady installed with this version: ${VERSION}"
    exit 0
fi

# script Dependencies
apt update


# java
if ! command -v java &> /dev/null
then
    apt install openjdk-17-jdk -y
fi


# delete temp folder if it exists
if [ -d "/tmp/signal-cli-install" ]
then
    rm -r /tmp/signal-cli-install
fi

mkdir /tmp/signal-cli-install

#Download signal-cli
curl --proto '=https' --tlsv1.2 -L -o /tmp/signal-cli-install/signal-cli-"${VERSION}"-Linux.tar.gz https://github.com/AsamK/signal-cli/releases/download/v"${VERSION}"/signal-cli-"${VERSION}"-Linux.tar.gz
tar xf /tmp/signal-cli-install/signal-cli-"${VERSION}"-Linux.tar.gz -C /opt
rm /tmp/signal-cli-install/signal-cli-"${VERSION}"-Linux.tar.gz
#Catch the good libsignal version from the previous signal-cli downloaded
export LIBVERSION=$(find /opt/signal-cli-"${VERSION}"/lib/ -maxdepth 1 -mindepth 1 -name 'libsignal-client-*' | sed -E 's/\/opt\/signal-cli-[0-9]{1,}.[0-9]{1,}.[0-9]{1,}\/lib\/libsignal-client-*//g' | sed -E 's/.jar//g')
ln -sf /opt/signal-cli-"${VERSION}"/bin/signal-cli /usr/local/bin/

# libsignal
#Download for 64bits distribution
#curl --proto '=https' --tlsv1.2 -L -o /tmp/signal-cli-install/libsignal.tar.gz https://github.com/exquo/signal-libs-build/releases/download/libsignal_v"${LIBVERSION}"/libsignal_jni.so-v"${LIBVERSION}"-aarch64-unknown-linux-gnu.tar.gz
#Download for octopi
curl --proto '=https' --tlsv1.2 -L -o /tmp/signal-cli-install/libsignal.tar.gz https://github.com/exquo/signal-libs-build/releases/download/libsignal_v"${LIBVERSION}"/libsignal_jni.so-v"${LIBVERSION}"-armv7-unknown-linux-gnueabihf.tar.gz
tar xf /tmp/signal-cli-install/libsignal.tar.gz -C /tmp/signal-cli-install/
rm /tmp/signal-cli-install/libsignal.tar.gz
#mv /tmp/signal-cli-install/libsignal-"${LIBVERSION}" /tmp/signal-cli-install/libsignal

# replace libsignal_jni.so
zip -d /opt/signal-cli-${VERSION}/lib/libsignal-client-*.jar libsignal_jni.so
zip /opt/signal-cli-${VERSION}/lib/libsignal-client-*.jar /tmp/signal-cli-install/libsignal_jni.so

# fallback of libsignal_jni.so
## create folder if it dosent exist
if [ -d "/usr/java/packages/lib" ]
then
    mkdir -p /usr/java/packages/lib
fi

## copy libsignal_jni.so to Java library path
cp  /tmp/signal-cli-install/libsignal_jni.so /usr/java/packages/lib

# permissions
chown root:root /usr/java/packages/lib/libsignal_jni.so
chmod 755 /usr/java/packages/lib/libsignal_jni.so
chmod 755 -R /opt/signal-cli-${VERSION}
chown root:root -R /opt/signal-cli-${VERSION}

# cleanup temp folder
rm -r /tmp/signal-cli-install

/opt/signal-cli-${VERSION}/bin/signal-cli --version

exit 0
