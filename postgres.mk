host     := localhost
user     := postgres
password := postgres
port     := 5432

ifneq (,$(wildcard ./.env))
    include .env
    export
endif

all:
	echo ${DB}
	echo ${DBUSER_MK}
	echo ${DBPWD_MK}

start_ctr:
	podman start postgres_ctr

stop_ctr:
	podman stop postgres_ctr

create_ctr:
	podman run --name postgres_ctr -p $(port):$(port) \
		-v $(PWD)/postgres.conf:/etc/postgresql/postgresql.conf \
		-e POSTGRES_USER=$(user) \
		-e POSTGRES_PASSWORD=$(password) \
		-d docker.io/postgres:15.1 \
		-c 'config_file=/etc/postgresql/postgresql.conf'

remove_ctr:
	podman stop postgres_ctr
	podman rm postgres_ctr

initDB:
	podman exec -it postgres_ctr psql -U $(user) -c "DROP DATABASE IF EXISTS ${DB};"
	podman exec -it postgres_ctr psql -U $(user) -c "DROP USER IF EXISTS ${DBUSER_MK};"
	podman exec -it postgres_ctr psql -U $(user) -c "CREATE USER ${DBUSER_MK} WITH ENCRYPTED PASSWORD '${DBPWD_MK}';"
	podman exec -it postgres_ctr psql -U $(user) -c "CREATE DATABASE ${DB} WITH OWNER ${DBUSER_MK} ENCODING 'UTF-8';"
	podman exec -it postgres_ctr psql -U $(user) -c "GRANT ALL PRIVILEGES ON DATABASE ${DB} TO ${DBUSER_MK};"
	podman cp $(PWD)/sample.sql postgres_ctr:/home/sample.sql
	podman exec -it postgres_ctr psql -f /home/sample.sql ${DB} ${DBUSER_MK}

shell:
	podman exec -it postgres_ctr psql -U ${DBUSER_MK} ${DB}
