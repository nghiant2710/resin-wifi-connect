#!/bin/bash

ARCHS='armv6hf armv7hf armel i386 amd64'
USER='nghiant2710'
REPO='resin-wifi-connect'

for ARCH in $ARCHS
do
	case "$ARCH" in
		'armv6hf')
			sed -e s~#{FROM}~resin/rpi-node:0.10.40-slim~g Dockerfile.tpl > Dockerfile
		;;
		'armv7hf')
			sed -e s~#{FROM}~resin/armv7hf-node:0.10.40-slim~g Dockerfile.tpl > Dockerfile
		;;
		'armel')
			sed -e s~#{FROM}~resin/armel-node:0.10.40-slim~g Dockerfile.tpl > Dockerfile
		;;
		'i386')
			sed -e s~#{FROM}~resin/i386-node:0.10.40-slim~g Dockerfile.tpl > Dockerfile
		;;
		'amd64')
			sed -e s~#{FROM}~resin/amd64-node:0.10.40-slim~g Dockerfile.tpl > Dockerfile
	esac
	docker build -t $USER/$REPO:$ARCH .
	docker push $USER/$REPO:$ARCH
done
