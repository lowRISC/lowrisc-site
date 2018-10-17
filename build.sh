hugo -b "https://www.cl.cam.ac.uk/~jrrk2"
echo >> public/robots.txt
echo 'Disallow: /' >> public/robots.txt
cp -pr public/* ~/public_html/
