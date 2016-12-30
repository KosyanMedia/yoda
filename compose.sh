#!/usr/bin/env bash
set -e

echo "# Build args $0 $*"
echo 'version: "2"'
echo 'networks:'
echo "  ${COMPOSE_PROJECT_NAME}:"
echo '    driver: host'
echo 'services:'

# Parse map
declare -A SCALE_MAP
for p in "$@"; do
  service=$(echo $p | cut -d'=' -f1)
  count=$(echo $p | cut -d'=' -f2)
  count=${count//[!0-9]/}
  SCALE_MAP["$service"]=$(( ${count:-1} - 1)) # Start index using 0
done

for p in ${!SCALE_MAP[*]}; do
  for i in $(seq 0 ${SCALE_MAP[$p]:-0}); do
    sed "s/^/  /g;s/#/$i/g" "$DOCKER_ROOT/containers/$p/container.yml"
  done
done
