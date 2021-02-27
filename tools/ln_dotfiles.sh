# !/bin/sh

# cd to script
cd `dirname $0`
pwd

abspath() {
  case $2 in
    /*) set -- "$1" "$2/" "" "" ;;
    *) set -- "$1" "${3:-$PWD}/$2/" "" ""
  esac

  while [ "$2" ]; do
    case ${2%%/*} in
      "" | .) set -- "$1" "${2#*/}" "${2%%/*}" "$4" ;;
      ..) set -- "$1" "${2#*/}" "${2%%/*}" "${4%/*}" ;;
      *) set -- "$1" "${2#*/}" "${2%%/*}" "$4/${2%%/*}"
    esac
  done
  eval "$1=\"/\${4#/}\""
}

relpath() {
  set -- "$1" "$2" "${3:-$PWD}"
  abspath "$@"
  eval "set -- \"\$1\" \"\${$1}\" \"\$3\""
  abspath "$1" "$3"
  eval "set -- \"\$1\" \"\$2\" \"\${$1}\" \"\""

  [ _"$2" = _"$3" ] && eval "$1=./" && return 0

  while [ "$3" ]; do
    eval "$1=\$3 && [ ! \"\$2\" = \"\${2#\"\${$1}\"}\" ]" && break
    set -- "$1" "$2" "${3%/*}" "../$4"
  done

  eval "$1=\$3/ && $1=\$4\${2#\"\${$1}\"}"
}

for filepath in $(find ../dotfiles -type f)
do
	filename=$(basename $filepath)
	abspath filepath_abs $filepath
  	mkdir -p $(dirname $HOME/${filepath#./dotfiles/})
	ln -sf $filepath_abs $HOME/${filepath#./dotfiles/}
done
