require 'coveralls'
Coveralls.wear!

require 'pry'
require 'rspec/its'
require 'bread/basket'

# Silence `puts` for nicer formatting
RSpec.configure do |c|
  c.before { allow($stdout).to receive(:puts) }
end
