# Basket

Basket is a tool for publishing scientific findings. It's the last piece of the :bread: framework for scientific computing.

For now it just makes scientific posters. In the future thought it should help make figures, presentations, and maybe even full journal articles.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bread-basket'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bread-basket

## Usage

The only tool in the Bread Basket is Posterize. You should call it from the command line with the path to your poster markdown file like so

    $ posterize my-poster.md

and it will produce a pdf that you can take to the printers. For more information on how to write the markdown file for you poster check out the website (doesn't exist yet).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/bread-basket/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
