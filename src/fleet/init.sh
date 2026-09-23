
# Sources '.env' file in this directory if present
#  `${${(%):-%N}:A:h}`: Resolve the directory containing this
#  sourced script (`:A` absolute, `:h` parent directory).
if [ -f "${${(%):-%N}:A:h}/.env" ]; then
  #echo "Sourcing file: "${${(%):-%N}:A:h}/.env""

  # shellcheck disable=SC1091
  source "${${(%):-%N}:A:h}/.env"
fi
