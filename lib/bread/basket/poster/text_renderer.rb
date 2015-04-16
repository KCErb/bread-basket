module Bread
  module Basket
    module Poster
      class TextRenderer < Redcarpet::Render::Base
        attr_reader :pdf, :layout, :box

        def preprocess(full_document)
          # First things first
          @pdf = Poster.pdf
          @layout = Poster.layout
          @box = Poster.current_box
          bounding_box_styles
          full_document
        end

        def bounding_box_styles
          pdf.font_size box.styles['font-size'] || layout.font_size
        end

        def alignment
          if box.styles['text-align']
            box.styles['text-align'].to_sym
          else
            :left
          end
        end

        # plain jane text
        def paragraph(text)
          pdf.text text, inline_format: true, align: alignment
        end

        # sections
        def header(_text, _header_level)
          # needs to be scss aware
        end

        # figure with caption
        def block_code(_caption, _image_path)
          caption
        end

        # > A pull quote
        def block_quote(_quote)
        end

        # *italic*
        def emphasis(text)
          "<i>#{text}</i>"
        end

        # **bold**
        def double_emphasis(text)
          "<b>#{text}</b>"
        end

        # _underline_
        def underline(text)
          "<u>#{text}</u>"
        end

        # super^script
        def superscript(text)
          "<sup>#{text}</sup>"
        end

        # code font
        def codespan(_text)
          # needs to be scss aware
        end

        # accent color
        def highlight(_text)
          # needs to be scss aware
        end

        # first thing called on each element, it's return
        # value gets added to the table row
        def table_cell(_content, _alignment)
        end

        # called after all cells, content is their contents joined
        def table_row(_content)
        end

        # called after all rows, header is header row, body is remaining rows.
        def table(_header, _body)
        end
      end
    end
  end
end
