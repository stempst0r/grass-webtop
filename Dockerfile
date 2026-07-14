ARG GRASS_VERSION=7.4.4

FROM lscr.io/linuxserver/webtop:ubuntu-xfce

LABEL maintainer="stempst0r <stempst0r@protonmail.com>"
LABEL description="Grass Desktop on linuxserver/webtop"

# Install dependencies needed by Grass
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    wget \
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
    && rm -rf /var/lib/apt/lists/*

# Download and install latest Grass Desktop
ARG GRASS_PACKAGE_URL="https://files.grass.io/file/grass-extension-upgrades/v${GRASS_VERSION}/grass-desktop_${GRASS_VERSION}_amd64.deb"

RUN wget -q -O /tmp/grass.deb ${GRASS_PACKAGE_URL} && \
    gdebi -n /tmp/grass.deb && \
    rm /tmp/grass.deb

# Copy autostart file
COPY autostart-grass.desktop /config/.config/autostart/grass.desktop

# Make sure permissions are correct
RUN chmod +x /config/.config/autostart/grass.desktop
