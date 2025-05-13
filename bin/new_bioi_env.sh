#!/bin/bash
# Usage: ./create_bioinfo_env.sh project_name

NAME=$1
PYTHON_VERSION=${2:-3.10}

cat > environment.yml << EOL
name: $NAME
channels:
  - conda-forge
  - bioconda
  - defaults
dependencies:
  - python=$PYTHON_VERSION
  - pandas
  - matplotlib
  - seaborn
  # Core bioinformatics tools
  - samtools
  - bwa
  - bedtools
EOL

echo "Created environment.yml for project $NAME with Python $PYTHON_VERSION"
