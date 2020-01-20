rm -rf public
hugo # -b "https://www.cl.cam.ac.uk/~jrrk2"
echo >> public/robots.txt
echo 'Disallow: /' >> public/robots.txt
cd public
rm -rf ~/public_html
mkdir -p ~/public_html
tar cf - . | tar xf - -C ~/public_html
cd ~/public_html
for i in `find . -type f`; do sed -i -e 's=lowrisc.org=cl.cam.ac.uk/~jrrk2=g' -e 's="/img="https://www.cl.cam.ac.uk/~jrrk2/img=g' $i; done
