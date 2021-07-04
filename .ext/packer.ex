#!/usr/bin/env sh
set -eu
[ "${DEBUG:-0}" = "1" ] && set -x

### Extension-specific variables
CLIV_E_NAME="${CLIV_E_NAME:-packer}"
CLIV_E_REV="0.2.0"
CLIV_E_BIN_NAME="${CLIV_E_BIN_NAME:-$CLIV_E_NAME}"
CLIV_E_DLFILE="${CLIV_E_DLFILE:-$CLIV_E_NAME.zip}"
CLIV_E_INSTDIR="${CLIV_E_INSTDIR:-$(pwd)}"
CLIV_E_OS="${CLIV_E_OS:-linux}"
CLIV_E_ARCH="${CLIV_E_ARCH:-amd64}"
CLIV_E_HCURL="https://releases.hashicorp.com/$CLIV_E_NAME"
CLIV_E_BASEURL="$CLIV_E_HCURL/%s/$CLIV_E_NAME""_%s_%s_%s.zip"
CLIV_E_BASEURL_ARGS='"${CLIV_E_VERSION}" "${CLIV_E_VERSION}" "${CLIV_E_OS}" "${CLIV_E_ARCH}"'
export CLIV_E_NAME CLIV_E_REV CLIV_E_BIN_NAME CLIV_E_DLFILE

### Extension-specific functions
_ext_versions () {  cliv -E "$CLIV_E_NAME" -X versions_hc "$CLIV_E_HCURL" ;  }
_ext_unpack () {  cliv -E "$CLIV_E_NAME" -X unpack_unzip "/usr/bin" ;  }

### The rest of this doesn't need to be modified
_ext_variables () { set | grep '^CLIV_E_' ; }
_ext_help () { printf "Usage: $0 CMD\n\nCommands:\n%s\n" "$(grep -e "^_ext_.* ()" "$0" | awk '{print $1}' | sed -e 's/_ext_//;s/^/  /g' | tr _ -)" ; }
if    [ $# -lt 1 ]
then  _ext_help ; exit 1
else  cmd="$1"; shift
      func="_ext_$(printf "%s\n" "$cmd" | tr - _)"
      [ -n "${CLIV_DIR:-}" -a -n "${CLIV_E_ENVIRON:-}" ] && [ -d "$CLIV_DIR/$CLIV_E_ENVIRON" ] && cd "$CLIV_DIR/$CLIV_E_ENVIRON"
      case "$cmd" in *) $func "$@" ;; esac
fi
