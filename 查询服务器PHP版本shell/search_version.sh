#!/bin/bash

function get_version {
	result=`which $1`
	if [[ -z ${result} ]]; then
		VERSION=$1' not found'
	else
		version_text=`$1 --version`
	    case $1 in
		'php')
			VERSION=${version_text: 0:11}
		;;
		'redis-cli')
			VERSION=${version_text: 0:16}
		;;
		'redis-server')
			VERSION=${version_text: 0:20}
		;;
		'mysql')
			VERSION=${version_text: 0:30}
		;;
		'memcached')
        	VERSION=${version_text: 0:18}
        ;;
		esac
	fi

	return 0
}

get_version php
echo 'PHP Version: '${VERSION}
get_version redis-cli
echo 'Redis-cli Version: '${VERSION}
get_version mysql
echo 'Mysql Version: '${VERSION}
get_version memcached
echo 'Memcached Version: '${VERSION}
