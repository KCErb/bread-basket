module Bread
  module Basket
    module Poster
      class BoxChecker
        # Determines which dimensions were provided and if provided dimensions
        # are sufficient to determine left, right, top, and width of box
        # bottom and height are optional but if top is missing are required to
        # determine location of top.
        attr_reader :box, :dimensions

        def initialize(box, dimensions)
          @box = box
          @dimensions = dimensions
        end

        def horizontal_dimensions
          arr = []
          dimensions.each_key do |key|
            arr << key if  %w(left right width).include? key
          end
          warn_right if arr.length > 2
          arr
        end

        def vertical_dimensions
          arr = []
          dimensions.each_key do |key|
            arr << key if  %w(top bottom height).include? key
          end
          warn_bottom if arr.length > 2
          arr
        end

        def horizontal_ok?
          horiz = %w(left right width) - horizontal_dimensions
          horiz.length < 2
        end

        def vertical_ok?
          bottom_and_height = %w(bottom height).all? { |s| dimensions.key? s }
          dimensions.key?('top') || bottom_and_height
        end

        def box_ok?
          horizontal_ok? && vertical_ok?
        end

        def warn_right
          puts "Warning: For selector #{box.selector_name}, left, width AND right were " \
                'provided. Right will be ignored.'
        end

        def warn_bottom
          puts "Warning: For selector #{box.selector_name}, top, height AND bottom were " \
                'provided. Bottom will be ignored.'
        end
      end
    end
  end
end
