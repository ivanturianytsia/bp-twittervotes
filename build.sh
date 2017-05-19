APPNAME="twittervotes"

function start {
  Y='\033[1;33m'
  NC='\033[0m'
  printf "${Y}\n - $@...\n${NC}"
}
function complete {
  G='\033[0;32m'
  NC='\033[0m'
  printf "${G}\n - Completed: $@.\n${NC}"
}
function build_binary_mac {
  STEPNAME="Building macOS binary"
  start $STEPNAME
  go get -v -d -t
  go test --cover -v ./...
  go build -v -o bin/twittervotes_mac .
  complete $STEPNAME
}
function build_binary_alpine {
  STEPNAME="Building Alpine Linux binary"
  start $STEPNAME
  go get -v -d -t
  go test --cover -v ./...
  CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -v -o bin/twittervotes_alpine .
  complete $STEPNAME
}
function build_binaries {
  build_binary_mac
  build_binary_alpine
}

function build_image {
  STEPNAME="Building Docker image"
  start $STEPNAME
  docker build -t ivanturianytsia/bp-twittervotes:latest .
  complete $STEPNAME
}
function push_image {
  STEPNAME="Push Docker image to Docker Hub"
  start $STEPNAME
  docker push ivanturianytsia/bp-twittervotes:latest

  docker tag ivanturianytsia/bp-twittervotes:latest ivanturianytsia/bp-twittervotes:$HASH
  docker push ivanturianytsia/bp-twittervotes:$HASH
  complete $STEPNAME
}

function deploy {
  STEPNAME="Deploy Docker service localy"
  start $STEPNAME

  docker service update \
    --image ivanturianytsia/bp-twittervotes:$HASH \
    bp-twittervotes

  complete $STEPNAME
}

HASH=$(git rev-parse HEAD)

case $1 in
  mac)
    build_binary_mac
    ;;
  alpine)
    build_binary_alpine
    ;;
  both)
    build_binaries
    ;;
  image)
    build_image
    ;;
  push)
    push_image
    ;;
  deploy)
    deploy
    ;;
  all)
    build_binaries
    build_image
    push_image
    ;;
esac
