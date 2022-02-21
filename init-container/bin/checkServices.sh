#!/usr/bin/env bash
set -euo pipefail
TRACE=${TRACE:-""}
DEBUG=${DEBUG:-""}
[ -n "$TRACE" ] || [ -n "$DEBUG" ] && set -x
IFS=$'\n\t;, '
log () { echo "$0($$)$(date +"%Y%m%d-%T") : $1"; }
log "Started"

# If "APP_NAME" environment value is not set or empty, apply default
APP_NAME=${APP_NAME:-"app"}
# If "SERVICES" environment value is not set or empty, apply default set
SERVICES=${SERVICES:-"${APP_NAME}-redis,${APP_NAME}-postgresql"}
# Fetch the namespace
NAMESPACE=$(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace)
# Check if we can resolve all K8s service IPs
for service in ${SERVICES}; do
    while ! nslookup "${service}.${NAMESPACE}.svc.cluster.local" >/dev/null 2>&1; do
        log "Can't resolve (${service}.${NAMESPACE}) in DNS, service is not ready yet(or there is no end points yet)." >&2
        sleep 1
    done
    log "Successfuly resolved (${service}.${NAMESPACE}) in DNS."
done
log "Ended"
exit 0


