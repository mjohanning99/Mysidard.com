#!/bin/bash
echo "The following program will update the Gemlog using gssr, convert all *.gmi pages to HTML (and convert their links too) and move the converted pages to HTML."
echo "Press Enter if you want to continue."
read enter

cd ..
echo "Removing contents of html directory. Continue?"
read enter
rm -rf html/*
cd gemlog/
gssg

cd ..
echo "Converting GMI to HTML and moving them to html directory. Continue?"
read enter
gmi-web --html en $(find . -name '*gmi')
rsync -rv --include '*/' --include '*.html' --exclude '*' --prune-empty-dirs . html --remove-source-files
rsync -rv --include '*/' --include '*.xml' --exclude '*' --prune-empty-dirs . html
find html/ -type f -name "*.html" -print0 | xargs -0 sed -i '' -e 's/\.gmi/\.html/g'