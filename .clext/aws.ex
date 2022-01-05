#!/usr/bin/env sh
set -eu
[ "${DEBUG:-0}" = "1" ] && set -x

### Extension-specific variables
CLINST_E_NAME="${CLINST_E_NAME:-aws}"
CLINST_E_REV="0.3.0"
CLINST_E_BIN_NAME="${CLINST_E_BIN_NAME:-aws}"
CLINST_E_DLFILE="${CLINST_E_DLFILE:-$CLINST_E_NAME.zip}"
CLINST_E_INSTDIR="${CLINST_E_INSTDIR:-$(pwd)}"
CLINST_E_OS="${CLINST_E_OS:-linux}"
CLINST_E_ARCH="${CLINST_E_ARCH:-x86_64}"
CLINST_E_GHREPOAPI="https://api.github.com/repos/aws/aws-cli"
CLINST_E_BASEURL="https://awscli.amazonaws.com/awscli-exe-%s-%s-%s.zip"
CLINST_E_BASEURL_ARGS='"${CLINST_E_OS}" "${CLINST_E_ARCH}" "${CLINST_E_VERSION}"'
export CLINST_E_NAME CLINST_E_REV CLINST_E_BIN_NAME CLINST_E_DLFILE

### Extension-specific functions
_ext_versions () {  clinst -E "$CLINST_E_NAME" -X versions_ghtags "$CLINST_E_GHREPOAPI" ;  }
_ext_unpack () {  clinst -E "$CLINST_E_NAME" -X unpack_unzip "/usr/share" ;  }
_ext_install_local () {  clinst -E "$CLINST_E_NAME" -X install_local "/usr/share/aws/dist/aws" ;  }

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
