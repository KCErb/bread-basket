require 'bread/basket/poster/poster_maker'
require 'bread/basket/poster/layout'
require 'bread/basket/poster/box_checker'
require 'bread/basket/poster/units_helper'
require 'bread/basket/poster/dimensions_helper'
require 'bread/basket/poster/box'
require 'bread/basket/poster/image_box'
require 'bread/basket/poster/columns'
require 'bread/basket/poster/css_reader'
require 'bread/basket/poster/renderer'

# Set-up module, so far the module houses one ivar and a constant
module Bread
  module Basket
    module Poster
      PDF = Prawn::Document.new

      class << self
        attr_accessor :dir_path, :layout
      end
    end
  end
end
