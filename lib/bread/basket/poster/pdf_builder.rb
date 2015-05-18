module Bread
  module Basket
    module Poster
      class PDFBuilder
        attr_reader :layout, :pdf, :text_renderer, :block_renderer, :wait_list

        def initialize
          @layout = Poster.layout
          @wait_list = []
          create_pdf
          create_renderers
        end

        def create_pdf
          page_size = [layout.width, layout.height]
          @pdf = Prawn::Document.new(page_size: page_size, margin: 0)
          Poster.pdf = @pdf
        end

        def create_renderers
          @text_renderer = Redcarpet::Markdown.new(TextRenderer, TEXT_RENDERER_OPTS)
          # @block_renderer = Redcarpet::Markdown.new(BlockRenderer)
        end

        def build
          layout.type == :block ? build_blocks : build_flow
        end

        def build_blocks
          # block_renderer.render layout.body
        end

        def build_flow
          image_boxes
          boxes_from_metadata
          create_columns
        end

        def boxes_from_metadata
          layout.metadata.each do |key, value|
            next unless layout.boxes.include? '.' + key
            box = layout.send key.gsub('-', '_')
            box.content = value.to_s
            try_to_build box
            try_wait_list # rename to try wait list and rewrite a little
          end
        end

        def try_to_build(box)
          if box.pending.empty?
            pdf_box = build_box(box)
            finish_stretchy_box(box, pdf_box) if box.stretchy?
          else
            wait_list << box unless wait_list.include? box
          end
        end

        def finish_stretchy_box(box, pdf_box)
          box.height = pdf_box.height
          box.determine_missing('bottom')
        end

        def try_wait_list
          layout.try_to_resolve_pendings
          wait_list.each { |box| try_to_build box }
        end

        def build_box(box)
          opts = { width: box.width }
          opts[:height] = box.height if box.height.is_a? Numeric

          pdf.bounding_box([box.left, box.top], opts) do
            Poster.current_styles = box.styles
            text_renderer.render box.content
          end
        end

        def create_columns
          pdf.column_box(left_top, column_box_opts) do
            Poster.current_styles = layout.column_styles
            text_renderer.render Poster.body
          end
        end

        def left_top
          left_edge = layout.columns[0].left
          top_edge = layout.columns[0].top
          [left_edge, top_edge]
        end

        def column_box_opts
          columns_width = pdf.bounds.width - 2 * layout.margin
          columns_height = left_top[1] - layout.margin
          { columns: 4, width: columns_width, height: columns_height }
        end

        def image_boxes
          layout.image_boxes.each do |box_name|
            image_box = layout.send box_name
            path = image_path(image_box)
            pdf.image path, fit: [image_box.width, image_box.height],
                            at: [image_box.left, image_box.top]
          end
        end

        def image_path(image_box)
          image_src = image_box.styles['src']
          Bread::Basket::Poster.dir_path + '/' + image_src
        end
      end
    end
  end
end
