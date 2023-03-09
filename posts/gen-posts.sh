#!/bin/bash
src=$(ls | grep "*.md")
for i in $src; do
    echo "converting $i"
    pandoc "$i".md -o "$i".html --parse-raw
done