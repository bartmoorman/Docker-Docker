FROM docker:latest

ARG TARGETOS \
    TARGETARCH \
    TARGETVARIANT

RUN apk add --no-cache \
    bash \
    curl \
    git \
    jq \
    wget \
 && if [ ${TARGETTARIANT} ]; then target=${TARGETOS}-${TARGETARCH}-${TARGETVARIANT}; else target=${TARGETOS}-${TARGETARCH}; fi \
 && fileUrl=$(curl --silent --location "https://api.github.com/repos/docker/buildx/releases/latest" | jq --arg target ${target} --raw-output '.assets[] | select(.name | endswith($target)) | .browser_download_url') \
 && wget --quiet --directory-prefix ~/.docker/cli-plugins "${fileUrl}" \
 && chmod a+x ~/.docker/cli-plugins/buildx-*.${target} \
 && ln -sf ~/.docker/cli-plugins/buildx-*.${target} ~/.docker/cli-plugins/docker-buildx \
 && git clone https://github.com/tfutils/tfenv.git ~/.tfenv \
 && ln -sf ~/.tfenv/bin/* /usr/local/bin
