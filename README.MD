
# FogLAMP Docker IOx Image

### Reset the ioxclient profile
ioxclient --profile -reset

### Build the Docker Image
docker build --rm -f "Dockerfile" -t jea-foglamp-docker-iox:v1.5.0 .

## From IOX client directory
### Save the Docker image to rootfs.tar so that ioxclient can package
docker save -o rootfs.tar jea-foglamp-docker-iox:v1.5.0

### Build the package
ioxclient pkg .

### Upload the package
ioxclient app add foglamp package.tar