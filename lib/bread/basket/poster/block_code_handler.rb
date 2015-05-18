module Bread
  module Basket
    module Poster
      class BlockCodeHandler
        attr_reader :pdf, :layout, :text_renderer

        def initialize(pdf, layout, first_line, content)
          @pdf = pdf
          @layout = layout
          @text_renderer = Redcarpet::Markdown.new(TextRenderer, TEXT_RENDERER_OPTS)
          sort_input(first_line, content)
        end

        def sort_input(first_line, content)
          case first_line
          when /\A.*\.(jpg|jpeg|png)\Z/
            create_image(first_line, content)
          else
            puts "Warning: Couldn't figure out what to do with #{content} block.\n"
          end
        end

        # TODO: Get a lot of these values from the CSS
        def create_image(image_src, caption)
          image_path = Bread::Basket::Poster.dir_path + '/' + image_src
          @columns_width = layout.columns[0].width
          pdf.image image_path, width: @columns_width, position: :center
          pdf.move_down 15
          draw_caption(caption)
        end

        def draw_caption(caption)
          top_left = [pdf.bounds.left + 20, pdf.cursor]
          pdf.bounding_box(top_left, width: @columns_width - 40) do
            # spin up a new renderer since this is called within one and Redcarpet
            # doesn't allow this: https://github.com/vmg/redcarpet/issues/318
            caption_content caption
          end
        end

        def caption_content(caption)
          pdf.stroke_bounds
          pdf.move_down 15
          text_renderer.render(caption)
          pdf.move_down 36
        end
      end
    end
  end
end
