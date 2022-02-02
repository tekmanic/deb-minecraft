FROM debian:bullseye-slim
LABEL org.opencontainers.image.authors="tekmanic"

# additional files
##################

# add supervisor conf file for app
ADD build/etc/*.conf /etc/
ADD build/*.conf /etc/supervisor/conf.d/

# add install bash script
ADD build/root/*.sh /root/

# get release tag name from build arg
ARG release_tag_name

# add run bash script
ADD run/nobody/*.sh /home/nobody/

# add utils scripts
ADD run/nobody/utils/*.sh /usr/local/bin/

# install app
#############

# make executable and run bash scripts to install app
RUN echo "**** install dependencies ****" && \
	apt-get update && \
	apt-get install -y \
	curl unzip wget make rsync screen jq coreutils moreutils net-tools supervisor htop python3 && \
	chmod +x /root/*.sh && \
	/bin/bash /root/install.sh

# docker settings
#################

# expose ipv4 port for minecraft
EXPOSE 19132/tcp
EXPOSE 19132/udp

# expose ipv6 port for minecraft
EXPOSE 19133/tcp
EXPOSE 19133/udp

# expose ipv4 port for minecraft web ui console
EXPOSE 8222/tcp

# set permissions
#################

# run script to set uid, gid and permissions
CMD ["/bin/bash", "/usr/local/bin/init.sh"]
# ENTRYPOINT [ "tail", "-f", "/dev/null" ]