#!/bin/bash

. ./var.sh
. ./public.sh
. ./conf.sh
. ./test.sh

[ $# -ne 1 ] && echo "sh $0 <deploy | clean | start | stop | details>"  && exit 1
action=$1

if [ x"$action"  == x"deploy" ];then
	[ ! -f $deploy_dir ] && ln -sf $bin_dir $deploy_dir

	[ -d "$deploy_dir/basedir" ] && echo "$deploy_dir already exist, exit!" && exit 1
	[ -d "$deploy_dir/datadir" ] && echo "$deploy_dir already exist, exit!" && exit 1

	mkdir -p $deploy_dir/basedir
	mkdir -p $deploy_dir/datadir

	write_mysql_conf $deploy_dir/basedir

	if [ ! -f $deploy_dir/bin/mysql_install_db ];then
		cp -f $deploy_dir/scripts/mysql_install_db $deploy_dir/bin/mysql_install_db
		chmod +x $deploy_dir/bin/mysql_install_db
	fi

	$deploy_dir/bin/mysql_install_db --user=root --basedir=$deploy_dir --datadir=$deploy_dir/datadir --no-defaults
	$deploy_dir/bin/mysqld_safe --defaults-file=$deploy_dir/basedir/my.cnf --user=root &

	sleep 3

	mysql_initialize

	mysql_details

elif [ x"$action" == x"clean" ];then
	ps -ef | grep mysql | grep -v grep | grep -v $sscript_name | awk '{print $2}' | xargs -I {} kill -9 {}

	rm -rf $deploy_dir/basedir
	rm -rf $deploy_dir/datadir
	rm -f $deploy_dir/bin/mysql_install_db
	rm -f $deploy_dir

elif [ x"$action" == x"start" ];then
	$deploy_dir/bin/mysql_install_db --user=root --basedir=$deploy_dir --datadir=$deploy_dir/datadir --no-defaults
	$deploy_dir/bin/mysqld_safe --defaults-file=$deploy_dir/basedir/my.cnf --user=root & 

elif [ x"$action" == x"stop" ];then
	ps -ef | grep mysql | grep -v grep | grep -v $sscript_name | awk '{print $2}' | xargs -I {} kill -9 {}

elif [ x"$action" == x"details" ];then
	mysql_details

elif [ x"$action" == x"test" ];then
	mysql_test

else
	echo "unsupport action: $action"
fi
