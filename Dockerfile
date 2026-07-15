# syntax=docker/dockerfile:1

ARG GRASS_VERSION=7.4.4

FROM lscr.io/linuxserver/webtop:ubuntu-xfce AS base

LABEL maintainer="stempst0r <stempst0r@protonmail.com>"
LABEL description="Grass Desktop on linuxserver/webtop"
LABEL version="${GRASS_VERSION}"

# Re-declare ARG
ARG GRASS_VERSION

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    gdebi-core \
    libayatana-appindicator3-1 \
    libwebkit2gtk-4.1-0 \
    libgtk-3-0 \
    libnotify4 \
    libnss3 \
    libxss1 \
    libxtst6 \
    libegl1 \
    libgles2 \
    libasound2t64 \
    && rm -rf /var/lib/apt/lists/* && apt-get clean

# === Download Grass (with retries + debug) ===
RUN echo "Downloading Grass Desktop v${GRASS_VERSION}..." && \
    curl -L -f --retry 5 --retry-delay 10 --retry-connrefused \
        --user-agent "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36" \
        --header "Accept: application/octet-stream" \
        --header "Referer: https://app.grass.io/" \
        -o /tmp/grass.deb \
        "https://files.grass.io/file/grass-extension-upgrades/v${GRASS_VERSION}/grass-desktop_${GRASS_VERSION}_amd64.deb" && \
    ls -lh /tmp/grass.deb && \
    echo "Download successful, installing..." && \
    gdebi -n /tmp/grass.deb && \
    rm -f /tmp/grass.deb

# Copy autostart
COPY autostart-grass.desktop /config/.config/autostart/grass.desktop

RUN chmod +x /config/.config/autostart/grass.desktop

# Final cleanup
RUN rm -rf /tmp/* /var/tmp/*
