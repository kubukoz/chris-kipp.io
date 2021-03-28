#!/usr/bin/env bash

TMPFILE=$(mktemp) || exit 1
DIVIDER="|||"

for file in `ls blogs/`; do
  DATE=`grep '^date:' blogs/$file | sed 's/date: //'`
  TITLE=`grep '^title:' blogs/$file | sed 's/title: //'`
  echo "$DATE $DIVIDER $TITLE" >> $TMPFILE
done

sort --reverse $TMPFILE --output $TMPFILE

while read line; do
  TITLE=${line#*$DIVIDER}
  DATE=${line%$DIVIDER*}
  URL=`sed 's/ /-/g' <<< $TITLE`
  BlOG_OVERVIEW="${BlOG_OVERVIEW}<li><span>${DATE}</span><a href=\"blog/${URL,,}\">${TITLE}</a></li>"
done < $TMPFILE

rm $TMPFILE

pandoc index.md \
  -f markdown \
  -t html5 \
  --variable overview="${BlOG_OVERVIEW}" \
  --template templates/index.html \
  -o site/index.html

echo "Created homepage"

pandoc about.md \
  -f markdown \
  -t html5 \
  --template templates/basic.html \
  -o site/about.html

echo "Created about page"

for file in `ls blogs/`; do
  TITLE=`grep '^title:' blogs/$file | sed 's/title: //' | sed 's/ /-/g'`
  pandoc blogs/$file\
    -f markdown \
    -t html5 \
    -s --highlight-style kate \
    --template templates/blog.html \
    -o site/${TITLE,,}.html

  echo "Created ${TITLE,,}.html"
done

echo "Site generated."

