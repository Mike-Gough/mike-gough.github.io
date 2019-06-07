# https://mike.gough.me

A personal website built on top of Jekyll and GitHub Pages.

## Prerequisites

You will need the following things properly installed on your computer.

* [Ruby](https://www.ruby-lang.org/en/documentation/installation/)
* [Jekyll](https://jekyllrb.com)

## Local development
### With Jekell
To build the site and start local web server, run the following command:
```
jekyll serve
```

To build the site and publish it into the `_site` folder, run the following command:
```
jekyll build
```
## With Docker
To build the site and publish it into the `_site` folder, run the following command:
```
docker run --rm -v /${PWD}:/srv/jekyll jekyll/jekyll jekyll build
```

## Further Reading / Useful Links

* [Ruby](https://www.ruby-lang.org/en/documentation/installation/)
* [Jekyll](https://jekyllrb.com)
* [Jekyll theme - Kasper](https://github.com/rosario/kasper.git)
* [GitHub Pages](https://pages.github.com)
