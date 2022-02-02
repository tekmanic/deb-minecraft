#!/bin/bash

function copy_minecraft(){

	# if minecraft server.properties file doesnt exist then copy default to host config volume
	if [ ! -f "/config/minecraft/server.properties" ]; then

		echo "[info] Minecraft server.properties file doesnt exist, copying default installation to '/config/minecraft/'..."

		mkdir -p /config/minecraft
		if [[ -d "/srv/minecraft" ]]; then
			cp -R /srv/minecraft/* /config/minecraft/ 2>/dev/null || true
		fi

	else

		# rsync options defined as follows:-
		# -r = recursive copy to destination
		# -l = copy source symlinks as symlinks on destination
		# -t = keep source modification times for destination files/folders
		# -p = keep source permissions for destination files/folders
		echo "[info] Minecraft folder '/config/minecraft' already exists, rsyncing newer files..."
		rsync -rltp --exclude 'worlds' --exclude '/server.properties' --exclude '/*.json' --exclude '*.debug' '/srv/minecraft/' '/config/minecraft'

	fi

	# if mods contains zip files then extract to /config/minecraft/behavior_packs
	if [[ -d "/config/minecraft/mods" ]]; then

		echo "[info] Checking for zip files in '/config/minecraft/mods'..."

		# loop through files in mods folder
		for file in /config/minecraft/mods/*.zip; do

			# if file is a zip file then extract to behavior_packs folder
			if [ -f "${file}" ]; then
			    name = $(basename -s .zip "${file}") 

				echo "[info] Extracting zip file '${file}' to '/config/minecraft/behavior_packs'..."

				# extract zip file to behavior_packs folder
				mkdir -p /config/minecraft/behavior_packs/${name}
				unzip -q -o "${file}" -d /config/minecraft/behavior_packs/${name}/

			fi

		done

	fi
}

function start_minecraft() {
	# print out the version
	echo "[info] Minecraft version: $(cat /srv/minecraft/version)" | ts '%Y-%m-%d %H:%M:%.S'

	# create logs sub folder to store screen output from console
	mkdir -p /config/minecraft/logs

	# run screen attached to minecraft (daemonized, non-blocking) to allow users to run commands in minecraft console
	echo "[info] Starting Minecraft Bedrock process..."
	screen -L -Logfile '/config/minecraft/logs/screen.log' -d -S minecraft -m bash -c "cd /config/minecraft && ./bedrock_server"
	echo "[info] Minecraft Bedrock process is running"
	if [[ ! -z "${STARTUP_CMD}" ]]; then
		startup_cmd
	fi
	cat

}

function startup_cmd() {

	# split comma separated string into array from STARTUP_CMD env variable
	IFS=',' read -ra startup_cmd_array <<< "${STARTUP_CMD}"

	# process startup cmds in the array
	for startup_cmd_item in "${startup_cmd_array[@]}"; do
		echo "[info] Executing startup Minecraft command '${startup_cmd_item}'"
		screen -S minecraft -p 0 -X stuff "${startup_cmd_item}^M"
	done

}

# copy/rsync minecraft to /config
copy_minecraft

# start minecraft
start_minecraft

# while true; do

# sleep 5;

# done;