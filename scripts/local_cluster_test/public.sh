
function mysql_initialize()
{
	set -x

	#解决mysql不用用户名密码可以直接登录的情况
	$deploy_dir/bin/mysql -h127.0.0.1 -P3306 -e "delete from mysql.user where user=''; flush privileges;"
	#修改密码
	$deploy_dir/bin/mysql -h127.0.0.1 -P3306 -e "update mysql.user set password=PASSWORD('root') where user='root'; flush privileges;"
	#新增用户，添加远程登录权限
	$deploy_dir/bin/mysql -h127.0.0.1 -P3306 -uroot -proot -e \
			"insert into mysql.user (host,user,password) values('localhost','user1',PASSWORD('123'));
			 GRANT ALL ON *.* TO 'user1'@'%' IDENTIFIED BY '123';
			 grant select,insert,update,delete on *.* to 'user1'@'localhost';
			 flush privileges;"

	set +x
}

function mysql_details()
{
	set -x
	
	$deploy_dir/bin/mysql -h127.0.0.1 -P3306 -uroot -proot -e "show databases;"
	$deploy_dir/bin/mysql -h127.0.0.1 -P3306 -uroot -proot -e "select user,host,Password from mysql.user;"

	set +x
}