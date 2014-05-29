#!/bin/sh
coberJarPath=/home/q/www/cobertools/cobertura_bak/cobertura.jar

coberLibPath=/home/q/tomcat/lib/cobertura.jar

if [ ! -f ${coberLibPath} ]
then
	echo "copy ${coberJarPath} to ${coberLibPath}"
	sudo cp -f ${coberJarPath} ${coberLibPath}
	sudo chown tomcat:tomcat ${coberLibPath}
	sudo chmod 777 ${coberLibPath}
fi

