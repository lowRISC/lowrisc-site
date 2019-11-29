hugo -b "https://www.cl.cam.ac.uk/~$USER"
echo >> public/robots.txt
echo 'Disallow: /' >> public/robots.txt
rsync -a --delete public/ ~/public_html
