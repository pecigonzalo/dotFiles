#!/bin/bash

[[ -f ~/.bashrc ]] && . ~/.bashrc
if [ -e /home/davyjones/.nix-profile/etc/profile.d/nix.sh ]; then . /home/davyjones/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
