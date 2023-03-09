#!/bin/bash

# Set the directory where Markdown files are located
md_dir="./posts"

# Set the directory where the HTML files will be saved
html_dir="./rendered"

# Set the name of the index file
index_file="index.html"
template_path="templates/post.html"
# Delete the existing index file if it exists
rm -f "${html_dir}/${index_file}"

# Loop through each Markdown file in the directory
for md_file in "${md_dir}"/*.md; do
  # Convert the Markdown file to HTML
  html_file="${html_dir}/$(basename "$md_file" .md).html"
  pandoc -f markdown -t html "${md_file}" --template="${template_path}" -o "${html_file}"

  # Get the title of the Markdown file
  title=$(grep -E '^# ' "${md_file}" | sed -e 's/^# //')

  # Add the HTML file as an entry in the index file
  echo "<li><a href=\"$(basename "$html_file")\">${title}</a></li>" >> "${html_dir}/temp.html"
done

# Add the list items to the body of the index file
sed -i '/<body>/r '${html_dir}/temp.html'' "./${index_file}"
rm -f "${html_dir}/temp.html"