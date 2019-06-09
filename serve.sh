docker container stop jekyll-blog-server || true
docker run --name jekyll-blog-server --rm -v /${PWD}:/srv/jekyll -p 4000:4000 jekyll/jekyll:3.8.5 jekyll serve --watch --drafts --force_polling
