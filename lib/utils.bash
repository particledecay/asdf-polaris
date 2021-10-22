#!/usr/bin/env bash

set -euo pipefail

GH_NAME="FairwindsOps/polaris"
GH_REPO="https://github.com/${GH_NAME}"
GH_API="https://api.github.com/repos/${GH_NAME}"
TOOL_NAME="polaris"
TOOL_TEST="polaris version"

fail() {
  echo -e "asdf-$TOOL_NAME: $*"
  exit 1
}

curl_opts=(-fsSL)

# NOTE: You might want to remove this if polaris is not hosted on GitHub releases.
if [ -n "${GITHUB_API_TOKEN:-}" ]; then
  curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
  sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
    LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

get_os() {
  uname | tr '[:upper:]' '[:lower:]'
}

get_arch() {
  local -r arch=$(uname -m)

  case $arch in
    x86_64)
      echo amd64
      ;;
    *)
      echo $arch
      ;;
  esac
}

list_github_tags() {
  git ls-remote --tags --refs "$GH_REPO" |
    grep -o 'refs/tags/.*' | cut -d/ -f3- |
    sed 's/^v//' # NOTE: You might want to adapt this sed to remove non-version strings from tags
}

list_github_releases() {
  local url
  url="${GH_API}/releases?per_page=100"

  curl "${curl_opts[@]}"  "$url" \
    | grep tag_name \
    | sed 's/"tag_name": //g;s/"//g;s/,//g'
}

list_all_versions() {
  list_github_releases
}

download_release() {
  local version filename url os arch legacy_tarball_version is_old_version
  version="$1"
  filename="$2"
  os=$(get_os)
  arch=$(get_arch)
  legacy_tarball_version="4.0.5" # this version and prior have older naming scheme
  is_old_version=$(echo $version $legacy_tarball_version \
    | xargs -n 1 \
    | sort_versions \
    | sed "/${legacy_tarball_version}/q" \
    | awk -v version=$version '$1 == version')

  echo "* Downloading $TOOL_NAME release $version..."
  if [ -n "$is_old_version" ]
  then
    remote_file="${TOOL_NAME}_${version}_${os}_${arch}.tar.gz"
  else
    remote_file="${TOOL_NAME}_${os}_${arch}.tar.gz"
  fi

  url="$GH_REPO/releases/download/$version/$remote_file"
  curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
  local install_type="$1"
  local version="$2"
  local install_path="$3"

  if [ "$install_type" != "version" ]; then
    fail "asdf-$TOOL_NAME supports release installs only"
  fi

  (
    mkdir -p "$install_path/bin"
    local tool_cmd
    tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"

    cp -r "$ASDF_DOWNLOAD_PATH/$tool_cmd" "$install_path/bin"

    test -x "$install_path/bin/$tool_cmd" || fail "Expected $install_path/bin/$tool_cmd to be executable."

    echo "$TOOL_NAME $version installation was successful!"
  ) || (
    rm -rf "$install_path"
    fail "An error ocurred while installing $TOOL_NAME $version."
  )
}
