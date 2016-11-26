#!/bin/sh

sassc styles.scss --style compressed | postcss --use autoprefixer > \
  ../static/css/styles.combined.min.css
