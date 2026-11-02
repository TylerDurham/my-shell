# brew.sh - install (or remove) the Homebrew package manager
#
# Homebrew refuses to run as root, so this module must be run as a normal
# user with sudo privileges (the installer uses sudo to create its prefix).

# -------------------------------------------------------------------------------------------------
# GLOBALS
# -------------------------------------------------------------------------------------------------

readonly CWD="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"                       # Current directory (relative to this file)
readonly BREW_URL="https://raw.githubusercontent.com/Homebrew/install/HEAD"         # Homebrew's install scripts
readonly DEPS=(xcode-command-line-tools)                                           # Needed to build/install brew

BUILD_DIR="" # Temporary download dir, set at install time

# -------------------------------------------------------------------------------------------------
# HOOKS
# -------------------------------------------------------------------------------------------------

# Called by source script. Initializes the module.
on_init() {
  info "initializing module '$(basename ${BASH_SOURCE[0]})'"

  debug "$FUNCNAME: checking environment..."
  check_environment

}

# Called by source script. Installs the module.
on_install() {
  info "installing module '$(basename "${BASH_SOURCE[0]}")'"
  debug "$FUNCNAME: installing brew..."
  install_brew
}

# Called by source script. Uninstalls the module.
on_uninstall() {
  info "uninstalling module '$(basename "${BASH_SOURCE[0]}")'"
  debug "$FUNCNAME: Removing brew..."
  uninstall_brew
}

on_completed() {
  info "module '$(basename $module)' completed!"
}

# -------------------------------------------------------------------------------------------------
# CORE FUNCTIONS
# -------------------------------------------------------------------------------------------------

# Check for macOS and sudo, and that we are not running as root.
check_environment() {
  [[ "$(uname -s)" == "Darwin" ]] ||
    fatal "uname is not Darwin - this script only supports macOS."

  [[ $EUID -ne 0 ]] ||
    fatal "Do not run this script as root; Homebrew refuses to run as root."

  command -v sudo >/dev/null 2>&1 ||
    fatal "sudo not found; it is required to install Homebrew."
}

is_installed() {
  case "$1" in
    xcode-command-line-tools) xcode-select -p >/dev/null 2>&1 ;;
    *) command -v "$1" >/dev/null 2>&1 ;;
  esac
}

# Drop the temporary download directory, however we leave the module.
cleanup() {
  if [[ -n "$BUILD_DIR" && -d "$BUILD_DIR" ]]; then
    rm -rf "$BUILD_DIR"
  fi
}

install_dependencies() {
  local missing=()
  local dep

  for dep in "${DEPS[@]}"; do
    is_installed "$dep" || missing+=("$dep")
  done

  if [[ ${#missing[@]} -eq 0 ]]; then
    debug "Build dependencies already present: ${DEPS[*]}"
    return
  fi

  # The Homebrew installer fetches the Command Line Tools itself when they
  # are missing, so there is nothing to install by hand here.
  debug "Missing build dependencies (${missing[*]}) will be installed by the Homebrew installer"
}

# Download the Homebrew installer and run it.
install_brew() {
  if command -v brew >/dev/null 2>&1; then
    info "brew is already installed ($(brew --version | head -n1)). Nothing to do."
    return
  fi

  install_dependencies

  BUILD_DIR="$(mktemp -d)"
  trap cleanup EXIT

  debug "Downloading the Homebrew installer..."
  curl -fsSL "$BREW_URL/install.sh" -o "$BUILD_DIR/install.sh"

  debug "Installing Homebrew (this may take a while)..."
  NONINTERACTIVE=1 /bin/bash "$BUILD_DIR/install.sh"

  local prefix
  for prefix in /opt/homebrew /usr/local; do
    [[ -x "$prefix/bin/brew" ]] && eval "$("$prefix/bin/brew" shellenv)" && break
  done

  command -v brew >/dev/null 2>&1 ||
    fatal "Install finished but brew is not on PATH; something went wrong."

    debug "Installed $(brew --version | head -n1)"
}

# Remove Homebrew, leaving the build dependencies in place.
uninstall_brew() {
  if ! is_installed brew; then
    warn "brew is not installed; nothing to remove."
    return
  fi

  BUILD_DIR="$(mktemp -d)"
  trap cleanup EXIT

  debug "Downloading the Homebrew uninstaller..."
  curl -fsSL "$BREW_URL/uninstall.sh" -o "$BUILD_DIR/uninstall.sh"

  debug "Removing Homebrew and everything it installed..."
  NONINTERACTIVE=1 /bin/bash "$BUILD_DIR/uninstall.sh"

  debug "brew removed. Build dependencies (${DEPS[*]}) were left in place."
}
