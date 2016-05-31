#!/bin/sh

mkdir -p /root/.gradle

if [ "${http_proxy}" != "" ]; then
  echo "systemProp.http.proxyHost=`echo ${http_proxy} | sed 's/.*\(:\/\/\|@\)//; s/:.*//;'`" >> /root/.gradle/gradle.properties
  echo "systemProp.http.proxyPort=`echo ${http_proxy} | sed 's/.*://;'`" >> /root/.gradle/gradle.properties

  if echo "${http_proxy}" | grep -q @; then
    echo "systemProp.http.proxyUser=`echo ${http_proxy} | sed 's/.*:\/\///; s/:.*//;'`" >> /root/.gradle/gradle.properties
    echo "systemProp.http.proxyPassword=`echo ${http_proxy} | sed 's/@.*//; s/.*://;'`" >> /root/.gradle/gradle.properties
  fi
fi

if [ "${https_proxy}" != "" ]; then
  echo "systemProp.https.proxyHost=`echo ${https_proxy} | sed 's/.*\(:\/\/\|@\)//; s/:.*//;'`" >> /root/.gradle/gradle.properties
  echo "systemProp.https.proxyPort=`echo ${https_proxy} | sed 's/.*://;'`" >> /root/.gradle/gradle.properties

  if echo "${https_proxy}" | grep -q @; then
    echo "systemProp.https.proxyUser=`echo ${https_proxy} | sed 's/.*:\/\///; s/:.*//;'`" >> /root/.gradle/gradle.properties
    echo "systemProp.https.proxyPassword=`echo ${https_proxy} | sed 's/@.*//; s/.*://;'`" >> /root/.gradle/gradle.properties
  fi
fi
