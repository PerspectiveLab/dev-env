# dev-env
Arch Linux development environment with Flutter SDK

The purpose of this repository is to create a consistent development environment for both the frontend and backend development. The packages list can be found in `pkgs.txt`.

#### Installation

`docker pull ghcr.io/perspectivelab/dev-env`

#### Usage

```
docker run -it \
    -v "$(pwd):/home/dev/perspective" \
    -v "[YOUR HOME DIRECTORY]/.gitconfig:/home/dev/.gitconfig" \
    -v "[YOUR HOME DIRECTORY]/.git-credentials:/home/dev/.git-credentials" \
    dev-env
```

Note: Your home directory must be an *absolute path*, e.g. /home/chinar
