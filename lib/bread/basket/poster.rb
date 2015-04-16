require 'bread/basket/poster/text_renderer'
require 'bread/basket/poster/block_renderer'
require 'bread/basket/poster/poster_maker'
require 'bread/basket/poster/layout'
require 'bread/basket/poster/box_checker'
require 'bread/basket/poster/units_helper'
require 'bread/basket/poster/dimensions_helper'
require 'bread/basket/poster/box'
require 'bread/basket/poster/image_box'
require 'bread/basket/poster/columns'
require 'bread/basket/poster/css_reader'
require 'bread/basket/poster/pdf_builder'

module Bread
  module Basket
    module Poster
      class << self
        attr_accessor :dir_path, :layout, :pdf, :current_box
      end
    end
  end
end
