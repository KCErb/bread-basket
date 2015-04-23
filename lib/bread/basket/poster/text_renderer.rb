module Bread
  module Basket
    module Poster
      class TextRenderer < Redcarpet::Render::Base
        attr_reader :pdf, :layout, :curr_styles

        def preprocess(full_document)
          @pdf = Poster.pdf
          @layout = Poster.layout
          @curr_styles = Poster.current_styles
          curr_styles['font-size'] = layout.font_size unless curr_styles.key? 'font-size'
          pdf.font_size curr_styles['font-size']
          full_document
        end

        def alignment
          if curr_styles['text-align']
            curr_styles['text-align'].to_sym
          else
            :left
          end
        end

        def paragraph(text)
          pdf.text text, inline_format: true, align: alignment
        end

        def header(text, _header_level)
          @header_maker = Poster::HeaderMaker.new(pdf, layout) unless @header_maker
          @header_maker.create_header(text, curr_styles)
        end

        # Very overloaded function for images, equations and maybe someday code
        def block_code(_caption, _image_path)
          # pdf.stroke_color 'ff0000'
          # pdf.move_down 36
          # pdf.stroke do
          #   pdf.rectangle [pdf.bounds.left, pdf.cursor], 100, 200
          # end
          # pdf.move_down 210
          # pdf.text caption
          # pdf.move_down 36
          # ''
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

        # inline `code span`
        def codespan(_text)
        end

        # inline ==highlighting==
        def highlight(text)
          color = layout.respond_to?(:highlight) ? layout.highlight['color'] : '#f700ff'
          color.sub!('#', '')
          "<color rgb='#{color}'>#{text}</color>"
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
