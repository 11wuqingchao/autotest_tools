#-*- coding:utf-8 -*- 

import sys
import re


for line in sys.stdin:
	if re.search("^TOMCAT_START_LOG",line):
		sys.stdout.write("TOMCAT_START_LOG=`cd /home/q/www/cobertools/"+sys.argv[1]+";$CATALINA_HOME/bin/startup.sh`\n")
	else:
		sys.stdout.write(line)
