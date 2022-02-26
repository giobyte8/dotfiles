# Gallery Pipeline

Automates periodic download and processing of my personal collections of
wallpapers, inpirational pictures and videos from sites such as Unsplash,
500px, Pinterest, etc.

Download of content is achieved through [gallery-dl](https://github.com/mikf/gallery-dl)

## Usage

1. `cp .env.template .
2. Make sure to update values in `.env` for your env

**Download single url:**
```bash
docker-compose run --rm --name gallerydl gallerydl <url>

# The first 'gallerydl' is the name for container (Optional)
# The second `gallerydl` is the name of the service from
#   docker-compose.yml used to create container
```

**Or paste all your desired urls into a file 'dlurls.txt` and use:**
```bash
docker-compose run --rm -v "${PWD}/dlurls.txt:/dl/dlurls.txt" gallerydl -i dlurls.txt

# Use this approach to for example collect urls during day and then schedule a
# cron job to download using file during night
# You may want to use -d after run for dettached mode
```

