#!/bin/bash

OPTS=""
LOGIN=""
PASSWORD=""
if [ "${http_proxy}" != "" ]; then
  LOGIN=`echo ${http_proxy} | sed 's/^.*:\/\///; s/:.*//;'`
  PASSWORD=`echo ${http_proxy} | sed 's/^[^@]*://; s/@.*//;'`
fi
if [ "${ANDROID_SDK_DOWNLOAD_PROXY_HOST}" != "" ]; then
  OPTS=" --proxy-host ${ANDROID_SDK_DOWNLOAD_PROXY_HOST} --proxy-port ${ANDROID_SDK_DOWNLOAD_PROXY_PORT}"
fi

CMD=`cat <<EOF
spawn ${ANDROID_HOME}/tools/android $@ $OPTS
set timeout 1800
expect {
  "Login: " {
    exp_send "$LOGIN\r"
    exp_continue
  }
  "Password: " {
    exp_send "$PASSWORD\r"
    exp_continue
  }
  "Workstation: " {
    exp_send "\r"
    exp_continue
  }
  "Domain: " {
    exp_send "\r"
    exp_continue
  }
  "Do you accept the license" {
    exp_send "y\r"
    exp_continue
  }
}
EOF
`

expect -c "$CMD"
