#!/usr/bin/env sh
set -eu
[ "${DEBUG:-0}" = "1" ] && set -x

### Extension-specific variables
CLINST_E_NAME="${CLINST_E_NAME:-eksctl}"
CLINST_E_REV="0.1.0"
CLINST_E_BIN_NAME="${CLINST_E_BIN_NAME:-$CLINST_E_NAME}"
CLINST_E_DLFILE="${CLINST_E_DLFILE:-$CLINST_E_NAME}.tgz"
CLINST_E_INSTDIR="${CLINST_E_INSTDIR:-$(pwd)}"
CLINST_E_OS="${CLINST_E_OS:-Linux}"
CLINST_E_ARCH="${CLINST_E_ARCH:-amd64}"
CLINST_E_GHREPOAPI="https://api.github.com/repos/weaveworks/$CLINST_E_NAME"
CLINST_E_BASEURL="https://github.com/weaveworks/$CLINST_E_NAME/releases/download/%s/${CLINST_E_NAME}_%s_%s.tar.gz"
CLINST_E_BASEURL_ARGS='"${CLINST_E_VERSION}" "${CLINST_E_OS}" "${CLINST_E_ARCH}"'
export CLINST_E_NAME CLINST_E_REV CLINST_E_BIN_NAME CLINST_E_DLFILE

### Extension-specific functions
_ext_versions () {
    CLINST_E_OS="$(echo $CLINST_E_OS | awk '{ print toupper(substr($0, 1, 1)) substr($0, 2) }')" \
        clinst -E "$CLINST_E_NAME" -X versions_ghreleases "$CLINST_E_GHREPOAPI" | grep -v -e "-rc\|alpha\|beta" | grep -e "^[0-9]"
}
_ext_unpack () {  clinst -E "$CLINST_E_NAME" -X unpack_untar "/usr/bin" ;  }
_ext_test () {  "$CLINST_E_INSTDIR/bin/$CLINST_E_BIN_NAME" version 2>/dev/null 1>/dev/null ;  }

### The rest of this doesn't need to be modified
_ext_variables () { set | grep '^CLINST_E_' ; }
_ext_help () { printf "Usage: $0 CMD\n\nCommands:\n%s\n" "$(grep -e "^_ext_.* ()" "$0" | awk '{print $1}' | sed -e 's/_ext_//;s/^/  /g' | tr _ -)" ; }
if    [ $# -lt 1 ]
then  _ext_help ; exit 1
else  cmd="$1"; shift
      func="_ext_$(printf "%s\n" "$cmd" | tr - _)"
      [ -n "${CLINST_DIR:-}" -a -n "${CLINST_E_ENVIRON:-}" ] && [ -d "$CLINST_DIR/$CLINST_E_ENVIRON" ] && cd "$CLINST_DIR/$CLINST_E_ENVIRON"
      case "$cmd" in *) $func "$@" ;; esac
fi
