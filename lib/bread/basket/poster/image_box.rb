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
          image_path = Bread::Basket::Poster.dirpath + '/' + specs['src']
          size = FastImage.size image_path
          # TODO: catch read fail, size will be nil
          # TODO: Assume printing at 72dpi, make that configurable?
          specs['width'] ||= size[0]
          specs['height'] ||= size[1]
        end
      end
    end
  end
end
