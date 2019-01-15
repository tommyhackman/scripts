#!/usr/bin/env bash
set -e

while getopts dp: opt; do
  case "$opt" in
  d)  echo "debug_opts" ;;
  p)  echo "Found the -b option, with parameter value $OPTARG" ;;
  *)  exit 2 ;;
  esac
done