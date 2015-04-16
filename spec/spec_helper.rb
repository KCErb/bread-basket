require 'coveralls'
Coveralls.wear!

require 'pry'
require 'rspec/its'
require 'bread/basket'

# Stub `puts` for quieter testing
RSpec.configure do |c|
  c.before { allow($stdout).to receive(:puts) }
end
