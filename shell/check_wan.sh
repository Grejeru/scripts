#!/bin/bash
# checking if multi-wan is being up/down and log those info

Color_Off='\e[0m'
BIBlack='\e[1;90m'      # Black
BIRed='\e[1;91m'        # Red
BIGreen='\e[1;92m'      # Green
BIYellow='\e[1;93m'     # Yellow
BIBlue='\e[1;94m'       # Blue
BIPurple='\e[1;95m'     # Purple
BICyan='\e[1;96m'       # Cyan
BIWhite='\e[1;97m'      # White

WAN1_NM='AerNetwork'
WAN1_IP='80.68.224.98'
WAN1_GW='80.68.224.97'
WAN2_NM='Connecta'
WAN2_IP='91.90.167.138'
WAN2_GW='91.90.167.137'

LOGSDIR='/config/scripts/logs'
CURDAY=$(date '+%Y%m%d')

if [ "$1" == "cron" ]; then

 fping -S ${WAN1_IP} ${WAN1_GW} > /dev/null 2>&1
 if [ $? == '0' ]; then
  if [ ! -f /tmp/${WAN1_NM}.up ]; then
   echo "$(date)" > /tmp/${WAN1_NM}.up
   rm -f /tmp/${WAN1_NM}.down
   echo "At $(date) is UP" >> ${LOGSDIR}/${WAN1_NM}.${CURDAY}
  else
   echo "$(date)" > /tmp/${WAN1_NM}.up
  fi
 else
  if [ ! -f /tmp/${WAN1_NM}.down ]; then
   echo "$(date)" > /tmp/${WAN1_NM}.down
   rm -f /tmp/${WAN1_NM}.up
   echo "At $(date) is DOWN" >> ${LOGSDIR}/${WAN1_NM}.${CURDAY}
  else
   echo "$(date)" > /tmp/${WAN1_NM}.down
  fi
 fi

 fping -S ${WAN2_IP} ${WAN2_GW} > /dev/null 2>&1
 if [ $? == '0' ]; then
  if [ ! -f /tmp/${WAN2_NM}.up ]; then
   echo "$(date)" > /tmp/${WAN2_NM}.up
   rm -f /tmp/${WAN2_NM}.down
   echo "At $(date) is UP" >> ${LOGSDIR}/${WAN2_NM}.${CURDAY}
  else
   echo "$(date)" > /tmp/${WAN2_NM}.up
  fi
 else
  if [ ! -f /tmp/${WAN2_NM}.down ]; then
   echo "$(date)" > /tmp/${WAN2_NM}.down
   rm -f /tmp/${WAN2_NM}.up
   echo "At $(date) is DOWN" >> ${LOGSDIR}/${WAN2_NM}.${CURDAY}
  else
   echo "$(date)" > /tmp/${WAN2_NM}.down
  fi
 fi

else
 echo -e "${BIYellow}$(date)${Color_Off}"

 # Check WAN1
 fping -S ${WAN1_IP} ${WAN1_GW} > /dev/null 2>&1
 if [ $? == '0' ]; then
  echo -e "${BIGreen}${WAN1_NM}${Color_Off}"
 else
  echo -e "${BIRed}${WAN1_NM}${Color_Off}"
 fi

 # Check WAN2
 fping -S ${WAN2_IP} ${WAN2_GW} > /dev/null 2>&1
 if [ $? == '0' ]; then
  echo -e "${BIGreen}${WAN2_NM}${Color_Off}"
 else
  echo -e "${BIRed{WAN2_NM}${Color_Off}"
 fi

# dig +short myip.opendns.com @resolver1.opendns.com
fi
