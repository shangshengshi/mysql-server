
function write_mysql_conf()
{
	conf_dir=$1
	cp $deploy_dir/support-files/my-small.cnf $conf_dir/my.cnf

	sed -i '/^socket/d' $conf_dir/my.cnf
	sed -i "/^port/a\socket=$deploy_dir/datadir/mysql.sock" $conf_dir/my.cnf

	echo "[mysqld]" >> $conf_dir/my.cnf
	echo "datadir = $deploy_dir/datadir" >> $conf_dir/my.cnf
	echo "basedir = $deploy_dir" >> $conf_dir/my.cnf
	echo "[mysqld_safe]" >> $conf_dir/my.cnf
	echo "log-error=$deploy_dir/mysqld.log" >> $conf_dir/my.cnf
	echo "pid-file=$deploy_dir/mysqld.pid" >> $conf_dir/my.cnf
}