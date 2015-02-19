# Basket

Basket is a tool for publishing scientific findings. It's the last piece of the :bread: framework for scientific computing.

For now it just makes scientific posters. In the future though, it should help make
figures, presentations, and maybe even full journal articles.

## Installation and Usage

Since :bread: hasn't been built (at all) yet, this little piece of the framework
is pretty lonely. As such the present intended use is just as a command-line utility.
For making scientific posters. To use it, first get it into your Ruby environment with

    $ gem install bread-basket

(If you're brand new to Ruby and not so sure about the above line, I plan to put
an introduction to Ruby for scientists on the bread homepage. So just sit tight
until I get that built.)

Once that's installed you should be able to convert a suitable markdown file
(with your poster's content) and stylesheet into a nice pdf like so

    $ bread-basket -p my-poster.md

and it will produce a pdf that you can take to the printers!

For more information on how to write the markdown file for your poster
check out the website (doesn't exist yet).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/bread-basket/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
