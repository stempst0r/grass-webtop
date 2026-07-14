# grass-webtop

Run the [Grass Desktop](https://www.grass.io/) node in a browser-accessible desktop, based on [linuxserver/webtop](https://github.com/linuxserver/docker-webtop).

## What this does

- Builds a Docker image with Grass Desktop pre-installed
- Auto-starts Grass when the desktop session loads
- Exposes the webtop UI on ports 3000 (HTTP) and 3001 (HTTPS)

## Quick start

### Option A: Use the pre-built image

```bash
cp docker-compose.yml.example docker-compose.yml
# Edit docker-compose.yml: set TZ, PASSWORD, and ports if needed
docker compose up -d
```

Open `http://<your-server-ip>:3000` and log in with the password you set.

### Option B: Build locally

```bash
docker build -t grass-webtop .
docker run -d \
  --name grass-webtop \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Europe/Berlin \
  -e PASSWORD=change-me \
  -p 3000:3000 \
  -p 3001:3001 \
  --shm-size=1g \
  --restart unless-stopped \
  grass-webtop
```

## Configuration

| Variable   | Description                          |
|------------|--------------------------------------|
| `PUID`     | User ID for file permissions         |
| `PGID`     | Group ID for file permissions        |
| `TZ`       | Timezone (e.g. `Europe/Berlin`)      |
| `PASSWORD` | Password for the webtop login screen |

Persist config and Grass data with the `grass_config` volume (see `docker-compose.yml.example`).

## Updating Grass version

Edit `GRASS_VERSION` in the `Dockerfile`, then rebuild the image.

## License

Use at your own risk. Grass Desktop is subject to Grass's own terms of service.