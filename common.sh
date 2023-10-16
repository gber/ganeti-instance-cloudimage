if [[ ${DEBUG_LEVEL} -gt 0 ]]; then
    set -x
fi

umask 077

export LC_ALL=C
export PATH=/usr/local/sbin:/sbin:/usr/sbin:/usr/local/bin:/bin:/usr/bin

[[ -f "/etc/default/ganeti-instance-cloudimage" ]] && \
    source /etc/default/ganeti-instance-cloudimage

: ${UNPRIV_USER:?missing UNPRIV_USER}
UNPRIV_GROUP=$(cut -d: -f4 <(getent passwd "${UNPRIV_USER}")) || exit $?
export CACHE_PATH="${CACHE_PATH:-/var/cache/ganeti-instance-cloudimage}"
export HTTP_PROXY HTTPS_PROXY ALL_PROXY NO_PROXY

declare -a _atexit_cmds
function atexit_handler {
    declare cmd

    for cmd in "${_atexit_cmds[@]}"; do
        eval "${cmd}"
    done
}
trap atexit_handler EXIT INT TERM

function atexit {
    _atexit_cmds=( "$1" "${_atexit_cmds[@]}" )
}
