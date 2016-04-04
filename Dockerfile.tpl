FROM #{FROM}

RUN apt-get update && apt-get install -y \
	bind9 \
	bridge-utils \
	connman \
	iptables \
	libdbus-1-dev \
	libexpat-dev \
	net-tools \
	usbutils \
	wireless-tools \
	git \
	&& rm -rf /var/lib/apt/lists/*

RUN systemctl disable connman

COPY ./assets/bind /etc/bind

RUN mkdir -p /usr/src/app/wifi-connect/
WORKDIR /usr/src/app/wifi-connect/

COPY package.json ./
RUN set -x \
	&& buildDeps=' \
		build-essential \
		python \
		python-dev \
	' \
	&& apt-get update && apt-get install -y $buildDeps --no-install-recommends && rm -rf /var/lib/apt/lists/* \
	&& JOBS=MAX npm install --unsafe-perm --production && npm cache clean \
	&& apt-get purge -y --auto-remove $buildDeps \
	&& rm -rf /usr/src/python

COPY bower.json .bowerrc ./
RUN ./node_modules/.bin/bower --allow-root install \
	&& ./node_modules/.bin/bower --allow-root cache clean

COPY entry.sh /usr/bin/entry.sh 
COPY . ./
RUN ./node_modules/.bin/coffee -c ./src

VOLUME /var/lib/connman
WORKDIR /usr/src/app/
