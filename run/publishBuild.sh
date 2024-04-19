docker buildx create --name mybuilder

docker buildx use mybuilder

docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 -t mitchellston/ring-mm-display:latest --push $(dirname "$0")

docker buildx rm --force mybuilder
