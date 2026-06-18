#!/usr/bin/env bash
# Export the entire OpenMRS concept dictionary (metadata) to a single .sql file.
# Usage: ./dump_concept_dictionary.sh > concept_dictionary.sql
set -euo pipefail

DB=openmrs
USER=root
# Add -p to be prompted for a password, or -p'secret' to inline it.

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
  --user="$USER" -p \
  --single-transaction \
  --no-tablespaces \
  --skip-add-locks \
  --complete-insert \
  "$DB" "${TABLES[@]}"
