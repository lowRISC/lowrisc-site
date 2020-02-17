rm -rf public
hugo # -b "https://www.cl.cam.ac.uk/~jrrk2"
echo >> public/robots.txt
echo 'Disallow: /' >> public/robots.txt
time for i in `find public -type f`; do sed -i -e 's=lowrisc.org=cl.cam.ac.uk/~jrrk2=g' -e 's="/img="https://www.cl.cam.ac.uk/~jrrk2/img=g' $i; done
mkdir -p ~/public_html
time rsync -a --delete public/ ~/public_html
