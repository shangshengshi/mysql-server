
function mysql_test()
{
	$deploy_dir/bin/mysql -h127.0.0.1 -P3306 -uroot -proot -e "create database if not exists mysql_test;"

	sql="CREATE TABLE IF NOT EXISTS mysql_test.table_test \
    	( \
        k1 BIGINT UNSIGNED NOT NULL, \
        k2 TINYINT UNSIGNED NOT NULL, \
        k3 INT UNSIGNED NOT NULL, \
        k4 SMALLINT UNSIGNED NOT NULL, \
        k5 BLOB NOT NULL, \
        k6 VARCHAR(20) NOT NULL, \
        PRIMARY KEY(k1, k2) \
    	) ENGINE=InnoDB DEFAULT CHARSET=utf8;"
    $deploy_dir/bin/mysql -h127.0.0.1 -P3306 -uroot -proot -e "$sql"

   	sql="ALTER TABLE mysql_test.table_test ADD INDEX id_k1(k1);"
   	$deploy_dir/bin/mysql -h127.0.0.1 -P3306 -uroot -proot -e "$sql"

    sql="SELECT * FROM information_schema.statistics where table_name='table_test' and index_name='id_k1'";
    $deploy_dir/bin/mysql -h127.0.0.1 -P3306 -uroot -proot -e "$sql"

    $deploy_dir/bin/mysql -h127.0.0.1 -P3306 -uroot -proot -e "delete from mysql_test.table_test;"
    sql="insert into mysql_test.table_test values(1, 2, 3, 4, '1234', '666'), (2, 3, 4, 5, '2345', '777'), \
    						(3, 2, 3, 4, '1234', '666'), (4, 3, 4, 5, '2345', '777');"
    $deploy_dir/bin/mysql -h127.0.0.1 -P3306 -uroot -proot -e "$sql"

    set -x
    $deploy_dir/bin/mysql -h127.0.0.1 -P3306 -uroot -proot -e "select * from mysql_test.table_test;"
    set +x

    sql="ALTER TABLE mysql_test.table_test DROP INDEX id_k1;"
   	$deploy_dir/bin/mysql -h127.0.0.1 -P3306 -uroot -proot -e "$sql"
}