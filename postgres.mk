ifneq (,$(wildcard ./.env))
    include .env
    export
endif

all:
	echo ${DB}
	echo ${DBUSER}
	echo ${DBPWD}
	echo $(shell echo ${DBPWD})

create_ctr:
	podman run --name postgres_ctr -p ${DBPORT}:${DBPORT} \
		-v $(PWD)/postgres.conf:/etc/postgresql/postgresql.conf \
		-e POSTGRES_USER=postgres \
		-e POSTGRES_PASSWORD=postgres \
		-d docker.io/postgres:15.1 \
		-c 'config_file=/etc/postgresql/postgresql.conf'
	sleep 2 # wait for container to start
	podman exec -it postgres_ctr psql -U postgres -c "DROP DATABASE IF EXISTS ${DB};"
	podman exec -it postgres_ctr psql -U postgres -c "DROP USER IF EXISTS ${DBUSER};"
	podman exec -it postgres_ctr psql -U postgres -c "CREATE USER ${DBUSER} WITH ENCRYPTED PASSWORD '$(shell echo ${DBPWD})';"
	podman exec -it postgres_ctr psql -U postgres -c "CREATE DATABASE ${DB} WITH OWNER ${DBUSER} ENCODING 'UTF-8';"
	podman exec -it postgres_ctr psql -U postgres -c "GRANT ALL PRIVILEGES ON DATABASE ${DB} TO ${DBUSER};"
	podman cp $(PWD)/sample.sql postgres_ctr:/home/sample.sql
	podman exec -it postgres_ctr psql -f /home/sample.sql ${DB} ${DBUSER}

remove_ctr:
	podman stop postgres_ctr
	podman rm postgres_ctr

start_ctr:
	podman start postgres_ctr

stop_ctr:
	podman stop postgres_ctr

shell:
	podman exec -it postgres_ctr psql -U ${DBUSER} ${DB}
