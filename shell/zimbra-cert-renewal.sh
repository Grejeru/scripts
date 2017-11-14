#!/bin/bash

if [ $# -eq 1 ]; then
  su - zimbra -c "zmproxyctl stop"
  su - zimbra -c "zmmailboxdctl stop"
  /usr/local/bin/certbot-auto renew

  if [ "$?" == "0" ]; then
    cp /etc/letsencrypt/live/${1}/* /opt/zimbra/ssl/letsencrypt/
    if [ "$?" == "0" ]; then
      cat /root/letsencrypt/root.pem >> /opt/zimbra/ssl/letsencrypt/chain.pem
      chown zimbra:zimbra /opt/zimbra/ssl/letsencrypt/*
      su - zimbra -c "cd /opt/zimbra/ssl/letsencrypt; /opt/zimbra/bin/zmcertmgr verifycrt comm privkey.pem cert.pem chain.pem"
      if [ "$?" == "0" ]; then
        cp -a /opt/zimbra/ssl/zimbra /opt/zimbra/ssl/zimbra.$(date "+%Y%m%d")
        cp /opt/zimbra/ssl/letsencrypt/privkey.pem /opt/zimbra/ssl/zimbra/commercial/commercial.key
        su - zimbra -c "cd /opt/zimbra/ssl/letsencrypt; /opt/zimbra/bin/zmcertmgr deploycrt comm cert.pem chain.pem"
        if [ "$?" == "0" ]; then
          su - zimbra -c "zmcontrol restart"
        else
          echo "cert deployment to zimbra failed"
        fi
      else
        echo "cert verification failed"
      fi
    else
      echo "letsencrypt missing that domain"
    fi
  else
    echo "failed to renew cert"
  fi
else
  echo "missing zimbra domain"
fi
