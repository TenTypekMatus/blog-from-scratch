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

  title=$(grep -E '^# ' "${md_file}" | sed -e 's/^# //')

  # Add the HTML file as an entry in the index file
  echo "<li><a href=\"${html_file}/$(basename "$html_file")\">${title}</a></li>" >> "${html_dir}/temp.html"
done
sed -i '/<body>/r '${html_dir}/temp.html'' "./${index_file}"
rm -f "${html_dir}/temp.html"