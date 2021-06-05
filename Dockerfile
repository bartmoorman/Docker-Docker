FROM docker:latest

ARG TARGETOS \
    TARGETARCH \
    TARGETVARIANT

RUN apk add --no-cache \
    curl \
    jq \
    wget \
 && if [ "${TARGETARCH}" = "arm" ]; then arch=${TARGETOS}-${TARGETARCH}-${TARGETVARIANT}; else arch=${TARGETOS}-${TARGETARCH}; fi \
 && fileUrl=$(curl --silent --location "https://api.github.com/repos/docker/buildx/releases/latest" | jq --arg arch ${arch} --raw-output '.assets[] | select(.name | endswith($arch)) | .browser_download_url') \
 && wget --quiet --directory-prefix ~/.docker/cli-plugins "${fileUrl}" \
 && chmod a+x ~/.docker/cli-plugins/buildx-*.${arch} \
 && ln -sf ~/.docker/cli-plugins/buildx-*.${arch} ~/.docker/cli-plugins/docker-buildx
