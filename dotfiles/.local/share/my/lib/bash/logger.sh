# =============================================
# Enhanced Bash Terminal Color & Style Library
# Supports: Colors + Bold, Dim, Italic, Underline
# =============================================

# Reset all attributes
NO_COLOR=
COLOR_RESET='\033[0m'

# === Text Styles ===
STYLE_BOLD='\033[1m'
STYLE_DIM='\033[2m'
STYLE_ITALIC='\033[3m'
STYLE_UNDERLINE='\033[4m'

# === Regular Colors ===
COLOR_BLACK='\033[30m'
COLOR_RED='\033[31m'
COLOR_GREEN='\033[32m'
COLOR_YELLOW='\033[33m'
COLOR_BLUE='\033[34m'
COLOR_PURPLE='\033[35m'
COLOR_CYAN='\033[36m'
COLOR_WHITE='\033[37m'

# === Bold Colors ===
COLOR_BBold='\033[1;30m'    # Bold Black
COLOR_BRed='\033[1;31m'
COLOR_BGreen='\033[1;32m'
COLOR_BYellow='\033[1;33m'
COLOR_BBlue='\033[1;34m'
COLOR_BPurple='\033[1;35m'
COLOR_BCyan='\033[1;36m'
COLOR_BWhite='\033[1;37m'

# === Bright / High Intensity Colors ===
COLOR_BIBlack='\033[0;90m'
COLOR_BIRed='\033[0;91m'
COLOR_BIGreen='\033[0;92m'
COLOR_BIYellow='\033[0;93m'
COLOR_BIBlue='\033[0;94m'
COLOR_BIPurple='\033[0;95m'
COLOR_BICyan='\033[0;96m'
COLOR_BIWhite='\033[0;97m'

# Background Colors (optional but useful)
COLOR_BGBlack='\033[40m'
COLOR_BGRed='\033[41m'
COLOR_BGGreen='\033[42m'
COLOR_BGYellow='\033[43m'
COLOR_BGBlue='\033[44m'
COLOR_BGPurple='\033[45m'
COLOR_BGCyan='\033[46m'
COLOR_BGWhite='\033[47m'

# =============================================
# Core Printing Functions
# =============================================

# General function: print with any style + color
print_style() {
    local style="$1"
    local text="$2"
    echo -e "${style}${text}${COLOR_RESET}" 
}

# Print with color only (convenience)
print_color() {
    print_style "$1" "$2"
}

# Print without newline
print_style_n() {
    local style="$1"
    local text="$2"
    echo -ne "${style}${text}${COLOR_RESET}"
}

# =============================================
# Styled Text Helper Functions
# =============================================

# Basic colored text
black()    { print_style "$COLOR_BLACK"    "$@"; }
red()      { print_style "$COLOR_RED"      "$@"; }
green()    { print_style "$COLOR_GREEN"    "$@"; }
yellow()   { print_style "$COLOR_YELLOW"   "$@"; }
blue()     { print_style "$COLOR_BLUE"     "$@"; }
purple()   { print_style "$COLOR_PURPLE"   "$@"; }
cyan()     { print_style "$COLOR_CYAN"     "$@"; }
white()    { print_style "$COLOR_WHITE"    "$@"; }

# Bold colored text
bold()          { print_style "$STYLE_BOLD"   "$@"; }
bold_black()    { print_style "$COLOR_BBold"    "$@"; }
bold_red()      { print_style "$COLOR_BRed"     "$@"; }
bold_green()    { print_style "$COLOR_BGreen"   "$@"; }
bold_yellow()   { print_style "$COLOR_BYellow"  "$@"; }
bold_blue()     { print_style "$COLOR_BBlue"    "$@"; }
bold_purple()   { print_style "$COLOR_BPurple"  "$@"; }
bold_cyan()     { print_style "$COLOR_BCyan"    "$@"; }
bold_white()    { print_style "$COLOR_BWhite"   "$@"; }

# Dim colored text
dim()          { print_style "$STYLE_DIM"                    "$@"; }
dim_black()    { print_style "${STYLE_DIM}${COLOR_BLACK}"    "$@"; }
dim_red()      { print_style "${STYLE_DIM}${COLOR_RED}"      "$@"; }
dim_green()    { print_style "${STYLE_DIM}${COLOR_GREEN}"    "$@"; }
dim_yellow()   { print_style "${STYLE_DIM}${COLOR_YELLOW}"   "$@"; }
dim_blue()     { print_style "${STYLE_DIM}${COLOR_BLUE}"     "$@"; }
dim_purple()   { print_style "${STYLE_DIM}${COLOR_PURPLE}"   "$@"; }
dim_cyan()     { print_style "${STYLE_DIM}${COLOR_CYAN}"     "$@"; }
dim_white()    { print_style "${STYLE_DIM}${COLOR_WHITE}"    "$@"; }

# Italic colored text
italic()          { print_style "$STYLE_ITALIC"   "$@"; }
italic_black()    { print_style "${STYLE_ITALIC}${COLOR_BLACK}"    "$@"; }
italic_red()      { print_style "${STYLE_ITALIC}${COLOR_RED}"      "$@"; }
italic_green()    { print_style "${STYLE_ITALIC}${COLOR_GREEN}"    "$@"; }
italic_yellow()   { print_style "${STYLE_ITALIC}${COLOR_YELLOW}"   "$@"; }
italic_blue()     { print_style "${STYLE_ITALIC}${COLOR_BLUE}"     "$@"; }
italic_purple()   { print_style "${STYLE_ITALIC}${COLOR_PURPLE}"   "$@"; }
italic_cyan()     { print_style "${STYLE_ITALIC}${COLOR_CYAN}"     "$@"; }
italic_white()    { print_style "${STYLE_ITALIC}${COLOR_WHITE}"    "$@"; }

# Underlined colored text
underline_black()    { print_style "${STYLE_UNDERLINE}${COLOR_BLACK}"    "$@"; }
underline_red()      { print_style "${STYLE_UNDERLINE}${COLOR_RED}"      "$@"; }
underline_green()    { print_style "${STYLE_UNDERLINE}${COLOR_GREEN}"    "$@"; }
underline_yellow()   { print_style "${STYLE_UNDERLINE}${COLOR_YELLOW}"   "$@"; }
underline_blue()     { print_style "${STYLE_UNDERLINE}${COLOR_BLUE}"     "$@"; }
underline_purple()   { print_style "${STYLE_UNDERLINE}${COLOR_PURPLE}"   "$@"; }
underline_cyan()     { print_style "${STYLE_UNDERLINE}${COLOR_CYAN}"     "$@"; }
underline_white()    { print_style "${STYLE_UNDERLINE}${COLOR_WHITE}"    "$@"; }

# Combined: Bold + Underline
bu_red()   { print_style "${STYLE_BOLD}${STYLE_UNDERLINE}${COLOR_RED}"   "$@"; }
bu_green() { print_style "${STYLE_BOLD}${STYLE_UNDERLINE}${COLOR_GREEN}" "$@"; }

# =============================================
# Text Case Conversion Functions
# =============================================

# Convert text to UPPERCASE
to_upper() {
    echo "${1^^}"
}

# Convert text to lowercase
to_lower() {
    echo "${1,,}"
}

# =============================================
# Demo Function
# =============================================

show_styles_demo() {
    echo -e "\n=== Terminal Style & Color Demo ===\n"

    echo "Regular colors:"
    red "Red" && green "Green" && yellow "Yellow" && blue "Blue"

    echo -e "\nBold text:"
    bold_red "Bold Red" && bold_green "Bold Green" && bold_blue "Bold Blue"

    echo -e "\nDim text:"
    dim_red "Dim Red" && dim_green "Dim Green"

    echo -e "\nItalic text:"
    italic_red "Italic Red" && italic_blue "Italic Blue"

    echo -e "\nUnderlined text:"
    underline_red "Underlined Red" && underline_green "Underlined Green"

    echo -e "\nCombined styles:"
    bu_red "Bold + Underlined Red"
    print_style "${STYLE_BOLD}${STYLE_ITALIC}${COLOR_PURPLE}" "Bold + Italic Purple"
}

# Optional: Auto-detect if colors are supported
if [[ -t 1 ]] && [[ -z "${NO_COLOR}" ]]; then
    : # Colors are enabled (stdout is terminal)
else
    # Disable all colors if not in terminal or NO_COLOR is set
    COLOR_RESET=""
    STYLE_BOLD="" STYLE_DIM="" STYLE_ITALIC="" STYLE_UNDERLINE=""
    COLOR_BLACK="" COLOR_RED="" COLOR_GREEN="" COLOR_YELLOW=""
    COLOR_BLUE="" COLOR_PURPLE="" COLOR_CYAN="" COLOR_WHITE=""
    COLOR_BBold="" COLOR_BRed="" COLOR_BGreen="" COLOR_BYellow=""
    COLOR_BBlue="" COLOR_BPurple="" COLOR_BCyan="" COLOR_BWhite=""
    COLOR_BIBlack="" COLOR_BIRed="" COLOR_BIGreen="" COLOR_BIYellow=""
    COLOR_BIBlue="" COLOR_BIPurple="" COLOR_BICyan="" COLOR_BIWhite=""
    COLOR_BGBlack="" COLOR_BGRed="" COLOR_BGGreen="" COLOR_BGYellow=""
    COLOR_BGBlue="" COLOR_BGPurple="" COLOR_BGCyan="" COLOR_BGWhite=""
fi

# Default log level (if nothing is set)
DEFAULT_LOG_LEVEL=1   # 8=DEBUG, 4=INFO, 2=WARN, 1=ERROR, 0=FATAL

# Use environment variable LOG_LEVEL if set, otherwise use default
# This allows: LOG_LEVEL=3 ./myscript.sh   or   export LOG_LEVEL=0

if [[ -v LOG_LEVEL ]] && [[ "$LOG_LEVEL" =~ ^[0-9]+$ ]]; then
    # LOG_LEVEL is already set from environment → keep it
    :
else
    # Not set or invalid → use default
    LOG_LEVEL="$@"
fi

# =============================================
# Log Level Check Function
# =============================================

# Returns 0 (success) if current LOG_LEVEL >= requested level
log_level_ge() {
    local level="$@"

    # Extra safety: ensure LOG_LEVEL is a number
    if [[ "$LOG_LEVEL" =~ ^[0-9]+$ ]]; then
        (( LOG_LEVEL >= level ))
        return $?
    else
        return 1
    fi
}

debug() {
  if log_level_ge 8; then
    echo "$(bold_purple $(to_upper $FUNCNAME)) $@" 
  fi
}

info() {
  if log_level_ge 4; then
    echo "$(bold_cyan $(to_upper $FUNCNAME)) $@" 
  fi
}

warn() {
  if log_level_ge 2; then
    echo "$(bold_yellow $(to_upper $FUNCNAME)) $@" 
  fi
}

error() {
  if log_level_ge 1; then
    echo "$(bold_red $(to_upper $FUNCNAME)) $@" 
  fi
}

fatal() {
  if log_level_ge 0; then
    echo "$(bold_red $(to_upper $FUNCNAME)) $@" >&2 
  fi
  exit 1
}

ok(){
  echo "✅ $@" 
}

notice() {
  echo "📣 $@" 
}

module() {
  local name="$1"
  echo -n "󰕳 "  
  print_style_n $COLOR_CYAN "$name "
  echo "${@:2}" 
}

package() {
  local name="$1"
  echo -n "󰏖 "  
  print_style_n $COLOR_CYAN "$name "
  echo "${@:2}" 
}

# indent - Indent text from stdin by a given amount
#
# Usage: <command> | indent [count] [char]
#
# Arguments:
#   count  Number of characters to indent (default: 2)
#   char   Character to use for indentation (default: space)
#
# Examples:
#   echo "hello" | indent
#   echo "hello" | indent 4
#   echo "hello" | indent 4 "-"
indent() {
  local count=${1:-2}
  local char=${2:-" "}
  local prefix=$(printf "%*s" "$count" | tr ' ' "$char")

  if [[ ! -t 0 ]]; then
    input=$(cat | sed '/^[[:space:]]*$/d')
     [[ -z "$input" ]] || printf '%s%s\n' "$prefix" "$input" 
  fi
}


