#!/bin/sh
coberPath=/home/q/tools/cobertura
for site in $*; do
    tomcatPath=/home/q/www/${site}
    classPath=${tomcatPath}/webapps/ROOT/WEB-INF/classes
    cleanPath=${tomcatPath}/coberclean

    if [ -f ${cleanPath}/clean.ser ]; then
        echo "Removing existing ${cleanPath}/clean.ser"
        sudo rm -f ${cleanPath}/clean.ser
    fi

    if [ -d ${classPath} ]; then
        echo "Removing original ${classPath}"
        sudo rm -rf ${classPath}
    fi

    echo "Create classes after instrument under ${classPath} using ${cleanPath}/classes"
    sudo ${coberPath}/cobertura-instrument.sh --datafile ${cleanPath}/clean.ser  ${classPath}
    #default ser file should be under tomcat start path.
    #already changed to $tomcatPath
    if [ -f ${tomcatPath}/cobertura.ser ]; then
        echo "Removing existing cobertura.ser under ${tomcatPath}"
        sudo rm -f ${tomcatPath}/cobertura.ser
    fi
    
    echo "Copy generated clean.ser to ${tomcatPath}"
    sudo cp -f ${cleanPath}/clean.ser ${tomcatPath}/cobertura.ser
    sudo chown tomcat:tomcat ${tomcatPath}/cobertura.ser
done
