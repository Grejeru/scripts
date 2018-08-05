#!/bin/bash

certname=$(hostname -f)
certcheck=$(certbot certificates --cert-name ${certname} 2>%1 | grep VALID | awk -F "VALID: " '{ print $2 }' | awk -F " days" '{ print $1 }')


function certrenew {

su - zimbra -c "zmproxyctl stop"
su - zimbra -c "zmmailboxdctl stop"
/usr/bin/certbot renew

if [ "$?" == "0" ]; then
  if [ ! -f /root/letsencrypt/root.pem ]; then
    mkdir -p /root/letsencrypt
    wget -O /root/letsencrypt/root.pem http://tmp.szary.sh/root.pem.txt
  fi
  mkdir -p /opt/zimbra/ssl/letsencrypt
  chown zimbra:zimbra /opt/zimbra/ssl/letsencrypt
  cp /etc/letsencrypt/live/${certname}/* /opt/zimbra/ssl/letsencrypt/
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
  echo "failed to renew cert"
fi
}

if [ "$1" == "renew" ]; then
  echo "$(date)"
  if [[ ${certcheck} = *"hour(s)"* ]]; then
    certrenew
  elif [[ ${certcheck} = "EXPIRED)" ]]; then
    certrenew
  elif [[ ${certcheck} -lt 7 ]]; then
    certrenew
  else
    echo "cert not yet due to renewal"
  fi
else
  echo "missing renew"
fi
