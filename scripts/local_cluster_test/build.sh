#!/bin/bash

# centos 6.6、gcc 4.4.7

. ./var.sh

cmake $proj_dir -DCMAKE_INSTALL_PREFIX=$bin_dir  -DMYSQL_DATADIR=$bin_dir/data  \
				-DWITH_INNOBASE_STORAGE_ENGINE=1  -DMYSQL_TCP_PORT=3306  -DMYSQL_UNIX_ADDR=$bin_dir/data/mysql.sock \
				-DMYSQL_USER=mysql  -DWITH_DEBUG=0

cd $proj_dir
make
make install

cd $work_dir

# 可能错误解决
# 1. Warning: Bison executable not found in PATH
#    
#    yum install bison