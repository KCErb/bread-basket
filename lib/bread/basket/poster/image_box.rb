module Bread
  module Basket
    module Poster
      class ImageBox < Box
        attr_reader :size
        attr_accessor :box_width, :box_height, :im_width, :im_height
        def setup_dimensions
          image_specs
          handle_width_and_height
          DimensionsHelper.new(self, layout, specs)
          layout.pending << selector_name unless pending.empty?
        end

        def image_specs
          image_path = Bread::Basket::Poster.dir_path + '/' + specs['src']
          @size = FastImage.size image_path
          read_fail(image_path) if size.nil?
          # TODO: Learn how printing resolution in images works with prawn
          # update: it's complicated!
        end

        def handle_width_and_height
          if specs['width'] || specs['height']
            # shuffle values around for fitting
            fitted_width_and_height
          else
            specs['width'] = size[0]
            specs['height'] = size[1]
          end
        end

        def fitted_width_and_height
          # set width and height from size if missing from css
          find_width_height
          # store these values as specifying the container's size, not
          # the image's actual final size
          specs['box_width'] = specs['width']
          specs['box_height'] = specs['height']
          # now use css notation to make this dependent on its own fitting so
          # that other Dimensions Mechanics can handle this normally
          specs['width'] = "#{method_name}.im_width"
          specs['height'] = "#{method_name}.im_height"
        end

        def find_width_height
          specs['width'] ||= size[0]
          specs['height'] ||= size[1]
        end

        def try_to_resolve
          if box_width.is_a?(Numeric) && box_height.is_a?(Numeric)
            fit_width_and_height
          end
          super
        end

        def fit_width_and_height
          if im_ratio > box_ratio
            w = box_width
            h = box_width / im_ratio
          else
            h = box_height
            w = box_height * im_ratio
          end
          add_to_determined('im_width', w)
          add_to_determined('im_height', h)
        end

        def box_ratio
          box_width / box_height.to_f
        end

        def im_ratio
          size[0] / size[1].to_f
        end

        def read_fail(image_path)
          message = "Couldn't find image for #{selector_name} at #{image_path}."
          layout.give_up(message)
        end

        def inspect
          str = ''
          %w(top left width height bottom right box_width box_height
             im_width im_height).each do |dim|
            str << "#{dim}: #{send(dim)}; "
          end
          str.strip
        end
      end
    end
  end
end
