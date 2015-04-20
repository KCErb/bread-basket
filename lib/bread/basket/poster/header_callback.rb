module Bread
  module Basket
    module Poster
      class HeaderCallback
        def initialize(document, options)
          @color = options['background-color']
          @document = document
          @radius = options['radius']
          @height = options['height']
          @width = options['width']
        end

        def render_behind(fragment)
          original_color = @document.fill_color
          vert_dist = (@height - fragment.height) / 2

          # TODO: If you want to get real picky, the vertical centering should
          # be aware of whether the text has ascenders or descenders, there's
          # a prawn method for calculating that sort of thing precisely.
          left_top = [@document.bounds.left, fragment.top + vert_dist]

          @document.fill_color = @color.sub('#', '')
          @document.fill_rounded_rectangle(left_top, @width, @height, @radius)
          @document.fill_color = original_color
        end
      end
    end
  end
end
