#!/bin/sh
source /etc/profile

if [ $# != 1 ] ; then
    echo "USAGE: $0 wwwname"
    exit 1;
fi

wwwname=$1



cd /home/q/www/cobertools/
sudo python /home/q/www/cobertools/cobertura_bak/mod.py ${wwwname} </home/q/tools/bin/start_tomcat.sh >/home/q/tools/bin/start_tomcat_${wwwname}.sh
#sudo cp /home/q/tools/bin/start_tomcat_new.sh /home/q/tools/bin/start_tomcat.sh
sudo /home/q/tools/bin/stop_tomcat.sh ${wwwname}
sudo chmod +x /home/q/tools/bin/start_tomcat_${wwwname}.sh
sudo /home/q/tools/bin/start_tomcat_${wwwname}.sh ${wwwname}
