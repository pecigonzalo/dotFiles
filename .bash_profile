#!/bin/bash

[[ -f ~/.bashrc ]] && . ~/.bashrc

[[ -e /home/davyjones/.nix-profile/etc/profile.d/nix.sh ]] && . ~/.nix-profile/etc/profile.d/nix.sh
