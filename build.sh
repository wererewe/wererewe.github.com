#!/bin/bash
case $1 in
    'build')
        bundle exec jekyll build;;
    'serve')
        bundle exec jekyll serve;;
    'serve-drafts')
        bundle exec jekyll serve --drafts;;
esac