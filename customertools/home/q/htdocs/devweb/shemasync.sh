#! /bin/sh

target_db_host=$1

#####db args##########
source_db_ip="192.168.234.194"
source_db_tts="demo_common"
source_db_client="demo_ota"

db_user="ttsuser"
db_pwd="123ababab"

target_db_ip=""
getipofdb() {
	if [[ $1 = "l-ttstest1.f.beta.cn6" ]]; then
		target_db_ip="192.168.234.194"
	elif [[ $1 = "l-ttstest2.f.beta.cn6" ]]; then
		target_db_ip="192.168.234.195"
	elif [[ $1 = "l-ttstest3.f.beta.cn6" ]]; then
		target_db_ip="192.168.234.196"
	elif [[ $1 = "l-ttstest4.f.beta.cn6" ]]; then
		target_db_ip="192.168.235.102"
	elif [[ $1 = "l-ttstest5.f.beta.cn6" ]]; then
		target_db_ip="192.168.235.103"
	elif [[ $1 = "l-ttstest6.f.beta.cn6" ]]; then
		target_db_ip="192.168.235.104"
	elif [[ $1 = "l-ttstest8.f.beta.cn6" ]]; then
		target_db_ip="192.168.235.106"
	elif [[ $1 = "l-qtest74.tc.beta.cn6" ]]; then
		target_db_ip="192.168.251.164"
	elif [[ $1 = "l-qtest75.tc.beta.cn6" ]]; then
		target_db_ip="192.168.251.165"
	fi
}

getipofdb $target_db_host
#echo $target_db_ip

if [[ -z  "$target_db_ip" ]]; then
	echo "not found target db!! please check host parameter"
	exit 1
fi

file_time=$(date +%Y%m%d-%H%M)
dump_command="mysqldump -u$db_user -p$db_pwd -h$source_db_ip -d --add-drop-table --lock-table=false"
#echo "$dump_command $source_db_tts > /home/q/htdocs/source/tts-$file_time.sql"
$dump_command $source_db_tts > /home/q/htdocs/source/tts-$file_time.sql
if [[ $? != 0 ]]; then
	echo "dump db tts failed!"
	exit 1
fi

#echo "$dump_command $source_db_client > /home/q/htdocs/source/client-$file_time.sql"
$dump_command $source_db_client > /home/q/htdocs/source/client-$file_time.sql
if [[ $? != 0 ]]; then
        echo "dump db tts_gn1 failed!"
        exit 1
fi

mysql_command="mysql -u$db_user -p$db_pwd -h$target_db_ip"
#echo "$mysql_command -e set names utf8; drop database if exists tts; create database tts"
$mysql_command -e "set names utf8; drop database if exists tts; create database tts"
if [[ $? != 0 ]]; then
        echo "re-create db tts failed!"
        exit 1
fi

#echo "$mysql_command tts < /home/q/htdocs/source/tts-$file_time.sql"
$mysql_command tts < /home/q/htdocs/source/tts-$file_time.sql
if [[ $? != 0 ]]; then
        echo "source db tts failed!"
        exit 1
fi

#echo "$mysql_command -e set names utf8; drop database if exists tts_gn1; create database tts_gn1"
$mysql_command -e "set names utf8; drop database if exists tts_gn1; create database tts_gn1"
if [[ $? != 0 ]]; then
        echo "recreate db tts_gn1 failed!"
        exit 1
fi

#echo "$mysql_command tts_gn1 < /home/q/htdocs/source/client-$file_time.sql"
$mysql_command tts_gn1 < /home/q/htdocs/source/client-$file_time.sql
if [[ $? != 0 ]]; then
        echo "source db tts_gn1 failed!"
        exit 1
fi

#echo "$mysql_command tts < /home/q/htdocs/source/defaultdata.sql"
$mysql_command tts < /home/q/htdocs/source/defaultdata.sql
if [[ $? != 0 ]]; then
        echo "insert default data into tts failed!"
        exit 1
fi

#echo "$mysql_command tts < /home/q/htdocs/source/storeprocedure.sql"
$mysql_command tts < /home/q/htdocs/source/storeprocedure.sql
if [[ $? != 0 ]]; then
        echo "insert store procedure into tts failed!"
        exit 1
fi

#echo "$mysql_command tts < /home/q/htdocs/source/defaultdata.sql"
$mysql_command tts_gn1 < /home/q/htdocs/source/clientdbchange.sql
if [[ $? != 0 ]]; then
        echo "db tts_gn1 structure change failed!"
        exit 1
fi

#echo "rm /home/q/htdocs/source/*$file_time.sql"
rm -r /home/q/htdocs/source/*$file_time.sql
exit 0
