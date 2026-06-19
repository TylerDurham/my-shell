#!/usr/bin/env bash
case "$(uname)" in
    Darwin)
        printf ' '
        ;;
    Linux)
        if [ -f /etc/arch-release ]; then
            printf '\uf303'  # Arch icon
        elif [ -f /etc/os-release ] && grep -qi 'nixos' /etc/os-release; then
            printf '\uf313'  # NixOS icon
        else
            printf '\uf17c'  # Generic Linux icon
        fi
        ;;
    *)
        printf '\uf109'  # Generic computer icon
        ;;
esac
