{ config, lib, pkgs, ... } @ moduleArgs:
{
  /*
    Setup docker CLI plugins:
    DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}
    mkdir -p $DOCKER_CONFIG/cli-plugins
    ln -s $(which docker-compose) $DOCKER_CONFIG/cli-plugins/docker-compose
    ln -s $(which docker-buildx) $DOCKER_CONFIG/cli-plugins/docker-buildx
  */
  home.packages = with pkgs; [
    docker-buildx
    docker-credential-helpers
    buildkit
  ] ++ lib.optionals (moduleArgs.osConfig.virtualisation.docker.enable or false) [
    docker
    docker-compose
  ];
}
