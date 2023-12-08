0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

_kv_dir=${KV_DB_DIR:-$XDG_DATA_HOME/kv}

kv-ensure-dir(){

    if ! zn-is-dir $1; then
        mkdir -p $1
        return $?
     else
         return 0
    fi
}

kv-get-path(){
  local key=$1
  echo "$_kv_dir/$1"
}

kv-value-path(){
    echo "$(kv-get-path $1)/__value"
}

kvput(){
    if [ $# -eq 2 ]; then
        local keypath="$(kv-get-path $1)"
        local key=${keypath##*/}
        [[ -n "$KV_VERBOSE" ]] && echo "setting $key=$2 (keypath=$keypath)"
        kv-ensure-dir $keypath || { echo "error creating kv $keypath: $?"; return 1; }
        echo "$2" > "$keypath/__value"
        return 0
    else
        echo "error: key and value are required"
        return 1
    fi
}

kvget() {
    if [[ $# -lt 1 ]]; then
        print "usage: $0 key [default]"
        return 1
    fi
    local key=${1}
    local vpath="$(kv-value-path $key)"
    if [[ ! -f "$vpath" ]]; then
        local default="${2}"
        if [[ -n "$default" ]]; then
            print "$default"
        fi
        return 1
    fi
    cat "$vpath"
    return $?
}

kviskey() {
    local key=${1:?"key required"}
    local vpath="$(kv-value-path $key)"
    builtin test -f "$vpath"
}

kvedit() {
  local key=$1
  local valuepath=$(kv-value-path $key)
  if [ ! -f "$valuepath" ]; then
      echo "key not found: $key"
      return 1
  else
      ${EDITOR:-nvim} "$valuepath"
      return $?
  fi
}

kvdel() {
    if [ $# -eq 1 ]; then
        rm -rf "$(kv-value-path $1)"
        return $?
    else
       echo "error: a key is required to delete a value"
    fi
}

kvpop() {
    local value=$(kvget $1)
    kvdel $1
    echo -n $value
}

kvls() {
    local keys=$(fd --print0 __value $_kv_dir)
    if [[ -z "$keys" ]]; then
        echo "no keys found"
    else
        echo -n "$keys" | xargs -0 -n1 dirname | sed -e "s#$_kv_dir/##g" | sort -
    fi
}

kv-ensure-dir $_kv_dir

kv_aliases=(
    kvdir 'print $_kv_dir'
)
zn-aliases $kv_aliases

zn-plugin-status $(zn-plugin-name "$0") "loaded"
