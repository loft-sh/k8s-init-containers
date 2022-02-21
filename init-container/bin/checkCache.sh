#!/usr/bin/env bash
set -euo pipefail
TRACE=${TRACE:-""}
DEBUG=${DEBUG:-""}
[ -n "$TRACE" ] || [ -n "$DEBUG" ] && set -x
IFS=$'\n\t;, '
log () { echo "$0($$)$(date +"%Y%m%d-%T") : $1"; }
log "Started"

# Make sure REDISCLI_AUTH environment value is set.
REDISCLI_AUTH=${REDISCLI_AUTH:?"REDISCLI_AUTH is not set."}
# If "CACHE_SERVICE" environment value is not set or empty, apply default set
CACHE_SERVICE=${CACHE_SERVICE:-"redis-master-0"}
# Fetch the namespace
NAMESPACE=$(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace)
# checkRedis executes redis-cli to determine if the database is ready.
checkRedis () {
    output=$(redis-cli -h "${CACHE_SERVICE}"."${NAMESPACE}".svc.cluster.local ping)
    statusCode=$?
    log "redis-cli says: ${output}"
    return $statusCode
}
# Check if we can connect to cache
while ! checkRedis; do
    log "Can't connect to (${CACHE_SERVICE}.${NAMESPACE}), cache is not ready yet." >&2
    sleep 1
done
log "Successfuly connected to (${CACHE_SERVICE}.${NAMESPACE}), cache is ready."
log "Ended"
exit 0


