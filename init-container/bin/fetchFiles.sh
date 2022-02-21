#!/usr/bin/env bash
set -euo pipefail
TRACE=${TRACE:-""}
DEBUG=${DEBUG:-""}
[ -n "$TRACE" ] || [ -n "$DEBUG" ] && set -x
IFS=$'\n\t;, '
log () { echo "$0($$)$(date +"%Y%m%d-%T") : $1"; }
log "Started"

# If "PUBLIC_ROOT" environment value is not set or empty, apply default
PUBLIC_ROOT=${PUBLIC_ROOT:-"/data/public"}

# Create public root directory if it doesn't exist.
if [ ! -d "$PUBLIC_ROOT" ]; then
	mkdir -p "$PUBLIC_ROOT" || echo "Failed to create public root directory." >&2; exit 1
fi

# Write the content into a file called index.html under the public directory.
cat <<- FILECONTENT > "${PUBLIC_ROOT}/index.html"
	<!doctype html>
	<html lang="en">
		<head>
			<title>my app</title>
		</head>
		<body>
			<h1>my app</h1>
		</body>
	</html>
FILECONTENT
# shellcheck disable=SC2181
if [ "$?" -eq 0 ]; then
	log "Files fetched successfuly."
else
	log "Couldn't fetch files."
	exit 1
fi
log "Ended"
exit 0