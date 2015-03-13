module Bread
  module Basket
    module Poster
      class Columns
        attr_reader :specs, :count, :layout, :tops, :width, :lefts, :boxes

        def initialize(specs, layout)
          @specs = specs
          @layout = layout
          check_specs
          @count = specs['count'].to_i
          init_tops
          init_widths
          init_lefts
          create_boxes
        end

        def init_tops
          if specs['top'].is_a? Array
            @tops = tops_from_arr
          else
            @tops = Array.new(count, specs['top'])
          end
        end

        def tops_from_arr
          case specs['top'].length
          when (count / 2.0).ceil
            symmetric_tops!
          when count
            specs['top']
          else
            message = 'Columns top specification has wrong length'
            layout.give_up(message)
          end
        end

        def symmetric_tops!
          arr = specs['top'].clone
          specs['top'].pop if count.odd?
          specs['top'].reverse!
          arr + specs['top']
        end

        def init_widths
          col_spacing = layout.font_size * (count - 1) # from Prawn
          @width = (columns_width - col_spacing) / count.to_f
        end

        def columns_width
          total_margin_space = 2 * layout.margin
          layout.width - total_margin_space
        end

        def init_lefts
          column_width = width + layout.font_size # again from Prawn
          @lefts = count.times.inject([layout.margin]) do |a|
            a << a[-1] + column_width
          end
          @lefts.pop
        end

        def create_boxes
          @boxes = []
          count.times do |index|
            box = Box.new "columns[#{index}]",
                          layout,
                          'top' => tops[index],
                          'left' => lefts[index],
                          'width' => width,
                          'bottom' => 'bottom + margin'
            @boxes << box
          end
        end

        def check_specs
          message = '.columns selector must include top and count to be valid'
          layout.give_up(message) unless top_and_count?
        end

        def top_and_count?
          %w(top count).all? { |attr| specs.key? attr }
        end
      end
    end
  end
end
