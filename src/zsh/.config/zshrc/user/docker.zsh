#!/usr/bin/env zsh

function docker_wipe() {
  echo "==> Killing all containers"
  docker ps -q | xargs docker kill

  echo "==> Removing all containers"
  docker ps -a -q | xargs docker rm

  echo "==> Removing orphaned containers (not defined in Compose file)"
  docker-compose down --remove-orphans

  echo "==> Removing all volumes"
  docker volume ls -q | xargs docker volume rm

  echo "==> Removing all images"
  docker images -q | xargs docker rmi

  echo "==> Removing unused data"
  docker system prune -a

  echo "==> Removing temporary or cached Docker Scout data"
  docker scout cache prune

  echo "==> Removing build cache (see also: docker builder rm)"
  docker builder prune
}
