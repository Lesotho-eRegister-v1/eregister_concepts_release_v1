#!/usr/bin/env bash
# Self-hosted runner for dump_concept_dictionary.sh.
#
# Runs the concept-dictionary dump from the HOST, executing mysqldump inside the
# Bahmni reports DB container and streaming the result to a .sql file on the host.
# No clone required — fetches the dump script straight from GitHub.
#
# Copy-paste one-liner:
#   curl -fsSL https://raw.githubusercontent.com/Lesotho-eRegister-v1/eregister_concepts_release_v1/main/run_concept_dump.sh | bash
#
# Overridable via environment, e.g.:
#   CONTAINER=bahmni-standard-reportsdb-1 DB=openmrs DB_USER=root \
#   OUT=my_dump.sql MYSQL_PWD=secret bash run_concept_dump.sh
set -euo pipefail

CONTAINER="${CONTAINER:-bahmni-standard-reportsdb-1}"
DB="${DB:-openmrs}"
DB_USER="${DB_USER:-root}"
OUT="${OUT:-omrs_concept_dictionary_$(date +%Y%m%d_%H%M%S).sql}"
RAW_BASE="https://raw.githubusercontent.com/Lesotho-eRegister-v1/eregister_concepts_release_v1/main"

# Prompt for the MySQL password unless it was already supplied via MYSQL_PWD.
if [[ -z "${MYSQL_PWD:-}" ]]; then
  read -rsp "MySQL password for ${DB_USER}@${CONTAINER}: " MYSQL_PWD
  echo
fi

# Make sure the target container exists and is running.
if [[ "$(docker inspect -f '{{.State.Running}}' "$CONTAINER" 2>/dev/null)" != "true" ]]; then
  echo "Error: container '$CONTAINER' is not running (or not found)." >&2
  echo "Set CONTAINER=<name> to target a different one." >&2
  exit 1
fi

echo "Dumping '$DB' from container '$CONTAINER' -> $OUT" >&2

# Fetch the dump script and run it INSIDE the container, streaming stdout to the host.
curl -fsSL "$RAW_BASE/dump_concept_dictionary.sh" \
  | docker exec -i \
      -e MYSQL_PWD="$MYSQL_PWD" \
      -e DB="$DB" \
      -e DB_USER="$DB_USER" \
      "$CONTAINER" bash -s > "$OUT"

if [[ ! -s "$OUT" ]]; then
  echo "Error: dump produced an empty file. Check the DB name, user, and password." >&2
  rm -f "$OUT"
  exit 1
fi

echo "Done. Wrote $(wc -l < "$OUT" | tr -d ' ') lines to $OUT" >&2
