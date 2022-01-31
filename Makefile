TOPDIR=$(PWD)

all: build run

run: build
	docker run -d \
    --net="bridge" \
    --name="minecraftserver" \
    -p 8222:8222/tcp \
    -p 19132:19132/tcp \
    -p 19132:19132/udp \
    -p 19132:19133/tcp \
    -p 19132:19133/udp \
    -v $(TOPDIR)/build:/config \
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
	deb-minecraft:latest

build:
	docker build -t deb-minecraft:latest .

slim:
	docker-slim build --dockerfile Dockerfile --tag deb-minecraft:slim .

clean:
	docker kill deb-minecraft || true
	docker rm -f deb-minecraft