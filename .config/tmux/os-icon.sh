#!/usr/bin/env bash
case "$(uname)" in
    Darwin)
        printf ' '
        ;;
    Linux)
        if [ -f /etc/arch-release ]; then
            printf '\uf303'  # Arch icon
        else
            printf '\uf17c'  # Generic Linux icon
        fi
        ;;
    *)
        printf '\uf109'  # Generic computer icon
        ;;
esac
