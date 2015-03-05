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
          init_width
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

        def init_width
          margin_spacing = 2 * layout.margin
          columns_width = layout.width - margin_spacing
          col_spacing = layout.font_size * (count - 1) # from Prawn
          @width = (columns_width - col_spacing ) / count.to_f
        end

        def init_lefts
          column_width = width + layout.font_size # again from Prawn
          @lefts = count.times.inject([layout.margin]) do |a, idx|
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
                          'width' => width
            @boxes << box
          end
        end

        def check_specs
          unless ['top', 'count'].all?{ |attr| specs.key? attr }
            message = ".columns selector must include top and count to be valid"
            layout.give_up(message)
          end
        end
      end
    end
  end
end
