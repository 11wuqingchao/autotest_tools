#!/bin/bash

#common command
TOMCAT_RESTART=/home/q/tools/bin/restart_tomcat.sh

#close all tomcat application
killalltomcatinstance(){
  echo "====close all tomcat instance===="
  for pid in `ps -ef | grep "tomcat" | grep "/home/q" | awk '{print $2}'`; do
    sudo kill -9 $pid;
  done
}

#check dubbo service whether service exported
dubbocheck(){
  echo "====check dubbo: $1 service===="
  for i in {1..20} ;do
    resultTxt=$(echo ls | nc -i 1 127.0.0.1 $1)
    if [ "$resultTxt" != "" ];then
      echo "====Start $2 Dubbo Service Succeed!!===="
      break
    fi
    sleep 2
  done
  if [ "$resultTxt" = "" ];then
    echo "====dubbo: $2 Dubbo service failures===="
    exit 1
  fi
}

#check tts java service whether starts succeed
httpcheck(){
  echo "====check http status===="
  for i in {1..20} ;do
    status=`curl -o /dev/null -s -w %{http_code} "http://127.0.0.1:$1" `
    if [ $status -eq 200 ];then
      echo "====start http succeed===="
      break
    fi
    sleep 2
  done
  if [ $status -ne 200 ];then
      echo "====start http failure==="
      exit 1
  fi
}

####kill all tomcat
killalltomcatinstance

step=1
#restart public
echo "==$step==restart public service===="
sudo $TOMCAT_RESTART public
dubbocheck 20885 public

step=`expr $step + 1`
echo "==$step==restart tts_tgqrule service===="
sudo sudo $TOMCAT_RESTART tts_tgqrule
dubbocheck 20993 tts_tgqrule

step=`expr $step + 1`
#restart voucher
echo "==$step==restart voucher service===="
sudo $TOMCAT_RESTART voucher
dubbocheck 20992 voucher

step=`expr $step + 1`
#restart invoice
echo "==$step==restart invoice service===="
sudo $TOMCAT_RESTART invoice
dubbocheck 20890 invoice

step=`expr $step + 1`
#restart policy
echo "==$step==restart policy service===="
sudo $TOMCAT_RESTART policy
dubbocheck 20886 policy

#restart b2b
#echo "==6==restart b2b service===="
#sudo $TOMCAT_RESTART b2b
#dubbocheck 20891 b2b

step=`expr $step + 1`
#restart pay
echo "==$step==restart pay service===="
sudo $TOMCAT_RESTART pay
dubbocheck 20887 pay

step=`expr $step + 1`
#restart ticket
echo "==$step==restart ticket service===="
sudo $TOMCAT_RESTART ticket
dubbocheck 20888 ticket

step=`expr $step + 1`
#restart ttsinsurance
echo "==$step==restart ttsinsurance service===="
sudo $TOMCAT_RESTART ttsinsurance
dubbocheck 20987 ttsinsurance

step=`expr $step + 1`
#restart ttssearch
echo "==$step==restart ttssearch service===="
sudo $TOMCAT_RESTART ttssearch
httpcheck "8085/healthcheck.html"
dubbocheck 20889 ttssearch

step=`expr $step + 1`
#restart ttsroundtripsearch
echo "==$step==restart ttsroundtripsearch service===="
sudo $TOMCAT_RESTART ttsroundtripsearch
dubbocheck 20789 ttsroundtripsearch

step=`expr $step + 1`
#restart 9csearch
echo "==$step==restart ttsroundtripsearch service===="
sudo $TOMCAT_RESTART 9csearch
dubbocheck 20895 9csearch

step=`expr $step + 1`
#restart tts_core
echo "==$step==restart tts java===="
sudo $TOMCAT_RESTART ttstw
dubbocheck 13839 ttstw
httpcheck "8080/config/healthcheck.jsp"


echo "================cong!!! all service restart succeed================="
