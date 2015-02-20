require 'spec_helper'

# Some bare-bones CLI specs. At this point the CLI is so simple
# I'm not sure that it needs real specs . . .

describe Bread::Basket::CLI do
  it 'has a run method' do
    expect(Bread::Basket::CLI.new).to respond_to(:run)
  end

  it 'has a parse! method' do
    expect(Bread::Basket::CLI.new).to respond_to(:parse!)
  end
end
