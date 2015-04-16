module Bread
  module Basket
    module Poster
      class BlockRenderer < TextRenderer
        attr_reader :pdf, :layout

        # create pdf bounding box
        def header(_text, _header_level)
          # needs to be scss aware
        end
      end
    end
  end
end
