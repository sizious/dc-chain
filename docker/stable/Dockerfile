# Stage 1
FROM alpine:latest as build
MAINTAINER KallistiOS <team@dreamsdk.org>

# Installing prerequisites
RUN apk --update add --no-cache \
	build-base \
	patch \
	bash \
	texinfo \
	libjpeg-turbo-dev \
	libpng-dev \
	curl \
	wget \
	git \
	python \
	subversion \
	&& apk --update add --no-cache libelf-dev --repository=http://dl-cdn.alpinelinux.org/alpine/v3.9/main \
	&& rm -rf /var/cache/apk/*

# Making Sega Dreamcast toolchains
RUN mkdir -p /opt/toolchains/dc \
	&& git clone https://git.code.sf.net/p/cadcdev/kallistios /opt/toolchains/dc/kos \
	&& cd /opt/toolchains/dc/kos/utils/dc-chain && ./download.sh && ./unpack.sh && make && make gdb \
	&& rm -rf /opt/toolchains/dc/kos

# Stage 2
FROM scratch
COPY --from=build / /
