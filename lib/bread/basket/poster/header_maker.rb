module Bread
  module Basket
    module Poster
      class HeaderMaker
        attr_reader :pdf, :layout, :styles

        HEADER_DEFAULTS =
        { 'font-size' => 36,
          'color' => '000000',
          'margin-top' => 0,
          'margin-bottom' => 0,
          'radius' => 0,
          'background-color' => 'ffffff',
          'font-family' => 'Helvetica'
        }

        def initialize(pdf, layout)
          @pdf = pdf
          @layout = layout
        end

        def create_header(text, styles)
          @text = text
          @styles = init_styles(styles)
          @header_callback = Poster::HeaderCallback.new(pdf, @styles)

          pdf.move_down top_margin
          pdf.formatted_text_box text_box_arr, text_box_opts
          pdf.move_down bottom_margin

          text # don't return a Numeric, Redcarpet hates that!
        end

        def init_styles(styles)
          styles = HEADER_DEFAULTS.merge layout_styles
          styles['width'] = layout.columns[0].width unless styles.key? 'width'
          styles['height'] = styles['font-size'] * 2 unless styles.key? 'height'
          styles
        end

        def layout_styles
          if layout.respond_to? :header
            layout.header
          else
            {}
          end
        end

        def text_box_arr
          [{ text: @text,
             callback: @header_callback,
             color: styles['color'].sub('#', ''),
             font:  styles['font-family'],
             size: styles['font-size']
            }]
        end

        def text_box_opts
          { at: [pdf.bounds.left, pdf.cursor],
            width: layout.columns[0].width,
            align: :center }
        end

        def top_margin
          styles['margin-top'] + (styles['height'] - styles['font-size']) / 2
        end

        def bottom_margin
          styles['margin-bottom'] + styles['height']
        end
      end
    end
  end
end
