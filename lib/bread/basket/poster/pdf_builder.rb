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
          text_opts = { fenced_code_blocks: true,
                        disable_indented_code_blocks: true,
                        underline: true,
                        highlight: true,
                        superscript: true,
                        tables: true }
          @text_renderer = Redcarpet::Markdown.new(TextRenderer, text_opts)
          # @block_renderer = Redcarpet::Markdown.new(BlockRenderer)
        end

        def build
          layout.type == :block ? build_blocks : build_flow
        end

        def build_blocks
          # block_renderer.render layout.body
        end

        def build_flow
          boxes_from_metadata
          create_columns
          # pdf.render_file "testerooony.pdf"
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
            Poster.current_box = box
            text_renderer.render box.content
          end
        end

        def create_columns
        end
      end
    end
  end
end
