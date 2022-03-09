#!/usr/bin/env bash
set -euo pipefail
TRACE=${TRACE:-""}
DEBUG=${DEBUG:-""}
[ -n "$TRACE" ] || [ -n "$DEBUG" ] && set -x
IFS=$'\n\t;, '
log () { echo "$(basename "$0")($$)$(date +"%Y%m%d-%T") : $1"; }
log "Started"

# If "SERVICES" environment value is not set or empty, apply default set
DB_SERVICE=${DB_SERVICE:-"postgresql"}
# Fetch the namespace
NAMESPACE=$(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace)

# checkPostgresql executes pg_isready to determine if the database is ready.
checkPostgresql () { 
    output=$(pg_isready -h "${DB_SERVICE}"."${NAMESPACE}".svc.cluster.local -U "${APP_NAME}" -d "${APP_NAME}" 2>&1)
    statusCode=$?
    log "pg_isready says: ${output}"
    return $statusCode
}
# Check if we can connect to database
while ! checkPostgresql; do
    log "Can't connect to (${DB_SERVICE}.${NAMESPACE}), database is not ready yet." >&2
    sleep 1
done
log "Successfuly connected to (${DB_SERVICE}.${NAMESPACE}), database is ready."
log "Finished"
exit 0


