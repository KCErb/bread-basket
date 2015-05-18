require 'bread/basket/poster/prawn_patches/column_box'
require 'bread/basket/poster/header_callback'
require 'bread/basket/poster/header_maker'
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
require 'bread/basket/poster/block_code_handler'

module Bread
  module Basket
    module Poster
      TEXT_RENDERER_OPTS = { fenced_code_blocks: true,
                             disable_indented_code_blocks: true,
                             underline: true,
                             highlight: true,
                             superscript: true,
                             tables: true }
      class << self
        attr_accessor :dir_path, :layout, :pdf, :current_styles, :body
      end

      # Default dir path, since in some specs this doesn't get set
      # this is a code smell and is on the to do list.
      dirname = File.dirname(__FILE__)
      Poster.dir_path = File.expand_path('../../../', dirname) + '/spec/poster/test_files'
      Poster.current_styles = {}
    end
  end
end
