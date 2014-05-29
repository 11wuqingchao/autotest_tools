#!/bin/sh
site=$1
tomcatPath=/home/q/www/${site}
classPath=${tomcatPath}/webapps/ROOT/WEB-INF/classes
cleanPath=${tomcatPath}/coberclean

if [ -d $cleanPath ]; then
    echo "Delete existing ${cleanPath}"
    sudo rm -rf $cleanPath
fi

echo "Creating new ${cleanPath}"
sudo mkdir -p $cleanPath
sudo chown tomcat:tomcat $cleanPath
echo "Copy original class: ${classPath} to ${cleanPath}"
sudo cp -rf $classPath $cleanPath
