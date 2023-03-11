#!/bin/bash
md_dir="./posts"
html_dir="./rendered"
index_file="index.html"
template_path="templates/post.html"
rm -f "${html_dir}/${index_file}"
for md_file in "${md_dir}"/*.md; do
  # Convert the Markdown file to HTML
  html_file="${html_dir}/$(basename "$md_file" .md).html"
  pandoc -f markdown -t html "${md_file}" --template="${template_path}" -o "${html_file}"
done