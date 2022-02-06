# deb-minecraft

[![docker-tag-triggered-prod](https://github.com/tekmanic/deb-minecraft/actions/workflows/docker-tag-triggered-prod.yaml/badge.svg)](https://github.com/tekmanic/deb-minecraft/actions/workflows/docker-tag-triggered-prod.yaml)

[Minecraft Bedrock Edition](https://www.minecraft.net/en-us/download/server/bedrock)

Minecraft is a sandbox video game created by Swedish game developer Markus Persson and released by Mojang in 2011. The game allows players to build with a variety of different blocks in a 3D procedurally generated world, requiring creativity from players. Other activities in the game include exploration, resource gathering, crafting, and combat. Multiple game modes that change gameplay are available, including—but not limited to—a survival mode, in which players must acquire resources to build the world and maintain health, and a creative mode, where players have unlimited resources to build with.

Latest alpha Minecraft Bedrock release from Mojang.

## Usage

```bash
docker run -d \
    --net="bridge" \
    --name=<container name> \
    -p <host port>:8222/tcp \
    -p <host port>:19132/tcp \
    -p <host port>:19132/udp \
    -p <host port>:19133/tcp \
    -p <host port>:19133/udp \
    -v <path for config files>:/config \
    -v /etc/localtime:/etc/localtime:ro \
    -e CREATE_BACKUP_HOURS=<frequency of world backups in hours> \
    -e PURGE_BACKUP_DAYS=<specify oldest world backups to keep in days> \
    -e ENABLE_WEBUI_CONSOLE=<yes|no> \
    -e ENABLE_WEBUI_AUTH=<yes|no> \
    -e WEBUI_USER=<specify webui username> \
    -e WEBUI_PASS=<specify webui password> \
    -e WEBUI_CONSOLE_TITLE=<specify webui console title> \
    -e STARTUP_CMD=<minecraft console command to execute on startup> \
    -e UMASK=<umask for created files> \
    -e PUID=<uid for user> \
    -e PGID=<gid for user> \
    binhex/arch-minecraftbedrockserver
```

&nbsp;
Please replace all user variables in the above command defined by <> with the correct values.

## Access Minecraft Server console

Requires `-e ENABLE_WEBUI_CONSOLE=yes`

`http://<host ip>:8222`

```bash
docker run -d \
    --net="bridge" \
    --name=minecraftbedrockserver \
    -p 8222:8222/tcp \
    -p 19132:19132/tcp \
    -p 19132:19132/udp \
    -p 19132:19133/tcp \
    -p 19132:19133/udp \
    -v /apps/docker/minecraftbedrockserver:/config \
    -v /etc/localtime:/etc/localtime:ro \
    -e CREATE_BACKUP_HOURS=12 \
    -e PURGE_BACKUP_DAYS=14 \
    -e ENABLE_WEBUI_CONSOLE=yes \
    -e ENABLE_WEBUI_AUTH=yes \
    -e WEBUI_USER=admin \
    -e WEBUI_PASS=minecraft \
    -e WEBUI_CONSOLE_TITLE='Minecraft Bedrock' \
    -e STARTUP_CMD=gamerule showcoordinates true \
    -e UMASK=000 \
    -e PUID=0 \
    -e PGID=0 \
    binhex/arch-minecraftbedrockserver
```

If you do **NOT** want world backups and/or purging of backups then set the value to '0' for env vars 'CREATE_BACKUP_HOURS' and/or 'PURGE_BACKUP_DAYS'.

User ID (PUID) and Group ID (PGID) can be found by issuing the following command for the user you want to run the container as:-

```bash
id <username>
```

## Custom server.properties and mods

If you want to customize the server, add the following to the minecraft folder:

- server.properties
- mods/the_mod.zip
- mods/world_behavior_packs.json

Make sure to unzip any of the mods inside their respective zip files, i.e. the mcaddon or mcpack formats are not recognized.  You will need to kill and readd the container such that the init.sh scripts are re-run and the server configuration is moved around.

---

The inspiration for this image comes from [binhex-minecraft](https://github.com/binhex/arch-minecraftbedrockserver).

---

If you appreciate my work, then please consider buying me a beer :D

[![PayPal donation](https://www.paypal.com/en_US/i/btn/btn_donate_SM.gif)](https://www.paypal.com/donate?hosted_button_id=KKQ4LNMEDVUPN)
