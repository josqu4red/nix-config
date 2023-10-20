function encode64() {
  echo -n $1 | base64
}

function decode64() {
  echo -n $1 | base64 -D
}

function del_known_host() {
  sed -i ${1}d ~/.ssh/known_hosts
}

function dockrun() {
  docker run --rm -it -w $(pwd) -v $(pwd):$(pwd) $@
}

function urlencode() {
  printf %s "$1" | jq -sRr @uri
}

function nixsh() {
  [ $# -lt 1 ] && echo "Need package argument(s)" && return
  pkgs=()
  for pkg in "$@"; do
    pkgs+=("/home/jamiez/code/nix-config#$pkg")
  done
  nix shell "${pkgs[@]}"
}

function ghclone() {
  dir="~/code/github.com/${1%/*}"
  mkdir -p $dir
  pushd $dir
  git clone https://github.com/$1
  popd
}
