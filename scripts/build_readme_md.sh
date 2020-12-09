#!/bin/bash
#
# Usage:
#
#   ./scripts_build_readme_md.sh
#
Rscript -e "devtools::build_readme()"
