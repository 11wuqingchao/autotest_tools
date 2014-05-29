#!/bin/sh
javaexec=/home/q/java/jdk*/bin/java

if [ $# -lt 1 ] ; then
    echo "USAGE: $0 site site ..."
    exit 1;
fi

coberJarPath=/home/q/www/cobertools/

site=$1

if [  -f ${coberJarPath}/${site}/cobertura.ser ]
then
   echo "清理环境"
   sudo rm -rf ${coberJarPath}/${site}/cobertura.ser 
	
fi

#for site in $* 
#do
     
cd ${coberJarPath}/${site}

tomcatPath=/home/q/www/${site}
classPath=${tomcatPath}/webapps/ROOT/WEB-INF/classes

echo "Processing ${classPath}"
insert=`exec /bin/su root -c "${coberJarPath}/cobertura_bak/cobertura-instrument.sh   ${classPath}"`    
if echo $insert | grep -q "Saved information on 0 classes"
then
    echo  insert coverage err
    exit 2
fi
sudo chown tomcat:tomcat ${coberJarPath}/${site}/cobertura.ser
sudo chmod 777 ${coberJarPath}/${site}/cobertura.ser   	
#done
