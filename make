#!/bin/bash

source ../aegis-docker/bin/aegis-config;
export container_name=mysql-dev;
export project_name=ubuntu-mysql;
export image_name=ubuntu-mysql;
export ip=${mysql_ip};
migration_dir=$(cd ../aegis-migration; pwd);
script_dir=$(cd `dirname $0`; pwd);
export create_param="-v $script_dir:/migrationtemp -v $migration_dir:/migration -e MYSQL_USER=mysql -e MYSQL_PASS=mysql -p 3306:3306"

# 重写mbt
mbt_rewrite;
start() {
    stat=`cstatus`;
    if [[ $stat = "exited" ]]; then
        if docker start $container_name > /dev/null 2>&1; then
            echo "$container_name is started" | color green bold;
        else
            echo "ERROR: $container_name fail to start" | color red bold;
        fi
		docker exec -i mysql-dev /migration/docker_migrate.sh up;
    elif [[ $stat = "running" ]]; then
        echo "$container_name already running!!!" | color yellow bold;
    else
        echo "$container_name does not exist, begin creating..." | color yellow bold;
        devCreate;
		docker exec -i mysql-dev /migration/docker_migrate.sh init;
    fi
}

staging() {
    stat=`cstatus`;
    if [[ $stat = "exited" ]]; then
        if docker start $container_name > /dev/null 2>&1; then
            echo "$container_name is started" | color green bold;
        else
            echo "ERROR: $container_name fail to start" | color red bold;
        fi
        docker exec -i mysql-dev /migration/docker_migrate.sh up;
    elif [[ $stat = "running" ]]; then
        echo "$container_name already running!!!" | color yellow bold;
    else
        echo "$container_name does not exist, begin creating..." | color yellow bold;
        stagingCreate;
        docker exec -i mysql-dev /migration/docker_migrate.sh init;
    fi
}

rebirth() {
    clean;
    image;
    devCreate;
    docker exec -i mysql-dev /migration/docker_migrate.sh init;
}

eval "$@"; 

