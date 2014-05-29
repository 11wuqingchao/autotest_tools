#!/bin/sh
coberPath=/home/q/tools/cobertura
sudo chown tomcat:tomcat ${coberPath} ${coberPath}/*

echo "Copy ${coberPath}/cobertura.jar to /home/q/tomcat/lib"
sudo cp -f ${coberPath}/cobertura.jar /home/q/tomcat/lib

for site in $*; do
    tomcatPath=/home/q/www/${site}
    echo "Copy ${coberPath}/coberturaFlush.war to ${tomcatPath}/webapps/"
    sudo cp -f ${coberPath}/coberturaFlush.war ${tomcatPath}/webapps/
    echo "unzip ${coberPath}/coberturaFlush.war -d ${tomcatPath}/webapps/coberturaFlush"
    sudo -u tomcat unzip -o ${coberPath}/coberturaFlush.war -d ${tomcatPath}/webapps/coberturaFlush
done
