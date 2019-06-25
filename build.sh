hugo -b "https://kimmitt.uk"
echo >> public/robots.txt
echo 'Disallow: /' >> public/robots.txt
rsync -a public/ admin@jrrk.jrrk.jrrk.uk0.bigv.io:kimmitt.uk/public/htdocs
