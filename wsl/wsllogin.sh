#!/bin/bash

sudo prlimit -p "$$" --nofile=10000:10000
