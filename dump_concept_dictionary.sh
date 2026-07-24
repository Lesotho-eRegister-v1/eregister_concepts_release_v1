#!/usr/bin/env bash
# Export the entire OpenMRS concept dictionary (metadata) to a single .sql file.
# Usage: ./dump_concept_dictionary.sh > concept_dictionary.sql
#
# Overridable via environment:
#   DB=openmrs        database to dump
#   DB_USER=root      MySQL user
#   MYSQL_PWD=secret  password (if unset, you'll be prompted with -p)
set -euo pipefail

DB="${DB:-openmrs}"
DB_USER="${DB_USER:-root}"

# If MYSQL_PWD is set, mysqldump picks it up automatically (non-interactive).
# Otherwise fall back to prompting for a password with -p.
PW_ARG=()
if [[ -z "${MYSQL_PWD:-}" ]]; then
  PW_ARG=(-p)
fi

# Dictionary tables listed parent-before-child so the dump re-imports cleanly.
TABLES=(
  concept_datatype
  concept_class
  concept_map_type
  concept_reference_source
  concept_stop_word
  concept_name_tag
  concept_attribute_type
  concept
  concept_name
  concept_description
  concept_numeric
  concept_complex
  concept_set
  concept_answer
  concept_attribute
  concept_name_tag_map
  concept_reference_term
  concept_reference_map
  concept_reference_term_map
  concept_state_conversion
  drug
  drug_ingredient
  drug_reference_map
)

mysqldump \
  --user="$DB_USER" "${PW_ARG[@]+"${PW_ARG[@]}"}" \
  --single-transaction \
  --no-tablespaces \
  --skip-add-locks \
  --complete-insert \
  "$DB" "${TABLES[@]}"
