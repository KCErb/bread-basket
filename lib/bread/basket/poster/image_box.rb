module Bread
  module Basket
    module Poster
      class ImageBox < Box
        include
        def setup_dimensions
          image_specs
          DimensionsHelper.new(self, layout, specs)
          layout.pending << selector_name unless pending.empty?
        end

        def image_specs
          image_path = Bread::Basket::Poster.dir_path + '/' + specs['src']
          size = FastImage.size image_path
          read_fail(image_path) if size.nil?
          # TODO: Learn how printing resolution in images works with prawn
          specs['width'] ||= size[0]
          specs['height'] ||= size[1]
        end

        def read_fail(image_path)
          message = "Couldn't find image for #{selector_name} at #{image_path}."
          layout.give_up(message)
        end
      end
    end
  end
end
