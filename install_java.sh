#!/bin/bash -eu

DEB_VERSION=$1

INSTALL_DIR=/opt/jvm/${DEB_VERSION}
mkdir -p ${INSTALL_DIR} /usr/local/lib/jvm/
curl -s http://archive.ubuntu.com/ubuntu/pool/main/o/openjdk-8/openjdk-8-jre_${DEB_VERSION}_amd64.deb | dpkg-deb -x - ${INSTALL_DIR}
curl -s http://archive.ubuntu.com/ubuntu/pool/main/o/openjdk-8/openjdk-8-jre-headless_${DEB_VERSION}_amd64.deb | dpkg-deb -x - ${INSTALL_DIR}
curl -s http://archive.ubuntu.com/ubuntu/pool/main/o/openjdk-8/openjdk-8-jdk_${DEB_VERSION}_amd64.deb | dpkg-deb -x - ${INSTALL_DIR}
curl -s http://archive.ubuntu.com/ubuntu/pool/main/o/openjdk-8/openjdk-8-jdk-headless_${DEB_VERSION}_amd64.deb | dpkg-deb -x - ${INSTALL_DIR}

ln -sfn ${INSTALL_DIR}/usr/lib/jvm/java-8-openjdk-amd64 /usr/local/lib/jvm/${DEB_VERSION}
ln -sfn /usr/local/lib/jvm/${DEB_VERSION} /usr/local/lib/jvm/java-8-openjdk-amd64
