ARG GRASS_VERSION=7.4.4

FROM lscr.io/linuxserver/webtop:ubuntu-xfce

LABEL maintainer="stempst0r <stempst0r@protonmail.com>"
LABEL description="Grass Desktop on linuxserver/webtop"
LABEL version="${GRASS_VERSION}"

# Re-declare ARG after FROM so it's available in RUN layers
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
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Download and install Grass Desktop
RUN echo "Downloading Grass v${GRASS_VERSION}..." && \
    curl -L -f --retry 3 --retry-delay 5 \
        --user-agent "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36" \
        --header "Accept: application/octet-stream" \
        -o /tmp/grass.deb \
        "https://files.grass.io/file/grass-extension-upgrades/v${GRASS_VERSION}/grass-desktop_${GRASS_VERSION}_amd64.deb" && \
    ls -lh /tmp/grass.deb && \
    gdebi -n /tmp/grass.deb && \
    rm -f /tmp/grass.deb

# Copy autostart file
COPY autostart-grass.desktop /config/.config/autostart/grass.desktop

# Set permissions
RUN chmod +x /config/.config/autostart/grass.desktop

# Cleanup
RUN rm -rf /tmp/* /var/tmp/*
