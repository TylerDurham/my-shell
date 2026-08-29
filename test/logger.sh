#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"

source "$REPO_ROOT/dotfiles/.local/share/my/lib/bash/logger.sh"

clear

echo "PRINTING ALL COLORS USING NAMED COLOR FUNCTIONS"
echo ""

for color in "${!COLORS[@]}"; do 
  echo $(${color,,} "Function '${color,,}()' called!")
  echo $(${color,,} "This text is ${color} and indented") | indent 1
  for style in "${!STYLES[@]}"; do 
    echo $(${style,,} $(${color,,} "This text is ${style} and ${color}"))
  done
  echo "The $(${color,,} quick) $(${style,,} brown) $(bold fox) $(bg_${color,,} $(bright_black jumped)) over the $(italic lazy) dog!"
  echo ""
done
echo ""

echo "PRINTING ALL STYLES USING NAMED STYLE FUNCTIONS"
echo ""

for style in "${!STYLES[@]}"; do 
  echo $(${style,,} "This text is $style")
done

bold "$(red err) tail"


echo ""
echo ""
echo "PRINTING ALL BADGES USING fmt_badge (ACCENT TEXT ON SURFACE GROUND)"
echo ""

for accent in red maroon peach yellow green teal sky sapphire blue lavender mauve pink overlay2; do
  fmt_badge "$accent" "$accent"
  printf ' '
done
echo ""
echo ""

echo "Badges sit inline with ordinary text:"
fmt_badge red ERROR;    echo " disk full on /dev/sda1"
fmt_badge yellow WARN;  echo " only 2% free"
fmt_badge green OK;     echo " all checks passed"
echo ""

echo "Every flavor keeps accent-on-surface0 above WCAG AA:"
for f in mocha macchiato frappe latte; do
  catppuccin_flavor "$f"
  fmt_badge red "$f"; printf ' '; fmt_badge blue "$f"; printf ' '; fmt_badge green "$f"; echo ""
done
catppuccin_flavor mocha
echo ""

echo "PRINTING BLOCKS USING fmt_block"
echo ""

echo "Ragged lines square up to the widest:"
fmt_block RED "Deploy failed" "check /var/log/deploy.log" "exit 1"
echo ""

echo "Reads stdin when given no text, so it works as a filter:"
printf '%s\n' "one" "two two two" "three" | fmt_block BLUE
echo ""

echo "Composes with indent:"
fmt_block GREEN "nested four spaces" "second line" | indent 4
echo ""

echo "Nested colors keep the rectangle flush:"
fmt_block BLUE "$(bright_yellow highlighted) and normal" "second line"
echo ""

echo "So do accents and wide characters:"
fmt_block CYAN "café" "日本語テスト" "plain ascii"
echo ""

echo "BLOCK_PAD controls the horizontal padding:"
BLOCK_PAD=0 fmt_block PURPLE "pad 0" "tight"
BLOCK_PAD=3 fmt_block PURPLE "pad 3" "roomy"
echo ""

info "Test"
info_badge "Test"

debug "Test"
debug_badge "Test"

error "Test"
error_badge "Test"

warn "Test"
warn_badge "Test"

fatal_badge  64 "Test fatal"
