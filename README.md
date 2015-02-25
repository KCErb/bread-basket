# Basket
[![Build Status](https://travis-ci.org/bread/bread-basket.svg?branch=master)](https://travis-ci.org/bread/bread-basket)
[![Coverage Status](https://coveralls.io/repos/bread/bread-basket/badge.svg?branch=master)](https://coveralls.io/r/bread/bread-basket?branch=master)

Basket is a tool for publishing scientific findings.
It's the last piece of the :bread: framework for scientific computing.
It is still being built just like the rest of bread, so don't try to use it yet!

When it is finished it will make scientific posters.
In the future though, it should help make
figures, presentations, and maybe even full journal articles.

## (Planned) Installation and Usage

Since :bread: hasn't been built (at all) yet, this little piece of the framework
is pretty lonely. So for now it's just a command-line utility
for making scientific posters. To use it, first get it into your Ruby environment with

    $ gem install bread-basket

(If you're brand new to Ruby and not so sure about the above line, I plan to put
an introduction to Ruby for scientists on the bread homepage. So just sit tight
until I get that built.)

Once that's installed you should be able to convert a suitable markdown file
(with your poster's content) and stylesheet into a nice pdf like so

    $ bread-basket poster my-poster.md

and it will produce a pdf that you can take to the printers!

For more information on how to write the markdown file for your poster
check out the website (doesn't exist yet).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/bread-basket/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
