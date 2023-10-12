SHELL := /bin/bash

default: run

args = `arg="$(filter-out $@,$(MAKECMDGOALS))" && echo $${arg:-${1}}`

build:
	docker build . -t zspotify-forked

run:
	# export VAR=https://open.spotify.com/track/56tNMHvbcFPvYiDxA7xROH\?si\=53adb99b87f24f50 && make run
	docker run -it \
		-v $$(pwd)/docker/config:/root/.config/ZSpotify \
		-v $$(pwd)/docker/download:/root/Music \
		zspotify-forked --skip-download -cf $$(pwd)/archive/credentials.json --track $$VAR

run-async:
	docker run -it \
		-v $$(pwd)/archive/:/root/archive/ \
		-v /Volumes/SANDISK\ 2/:/root/Music \
		-d --name zspotify_container zspotify-forked

start:
	# reboot a stopped container 
	docker start zspotify_container

run-ssh:
	docker run -it \
		-v $$(pwd)/archive/:/root/archive/ \
		-v /Volumes/SANDISK\ 2/:/root/Music \
		-d --name zspotify_container zspotify-forked sh
	docker exec -it zspotify_container sh
	# then, in the container, run:
		# ZSpotify --skip-download --track <track_url>
	# songs are saved to root/Music/ZSpotify\ Music/
	# --not-skip-existing
	# -d, --detach => detach the container process and run it in the background
	# To exit the running container without stopping it press `Ctrl-P`, followed by `Ctrl-Q`

ssh:
	docker exec -it zspotify_container sh

exec:
	docker exec -it zspotify_container zspotify --archive /root/archive/archive.json -cf /root/archive/credentials.json --track $$VAR

copy-creds:
	docker cp $$(docker ps -aqf "name=zspotify_container"):/credentials.json $$(pwd)/

copy-creds-to-container:
	docker cp $$(pwd)/archive/credentials.json $$(docker ps -aqf "name=zspotify_container"):/

pip-download:
	zspotify -tr $$VAR -md /Volumes/SANDISK\ 2/ZSpotify\ Music/ -cf $$(pwd)/archive/credentials.json --archive $$(pwd)/archive/archive.json
# 	zspotify -tr $$VAR -md /Users/conorsheppard/Downloads/ -cf $$(pwd)/archive/credentials.json --archive $$(pwd)/archive/archive.json

.PHONY: default run build run run-async start run-ssh ssh exec copy-creds copy-creds-to-container
