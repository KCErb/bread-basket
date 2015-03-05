module Bread
  module Basket
    module Poster
      class Box
        # Box does most of the heavy lifting of the self-referential css
        # so it's a little confusing. I'm planning to write up an explanation
        # on the wiki.
        attr_reader :name, :layout, :dimensions, :top, :left, :width, :height,
                    :bottom, :right, :pending

        def initialize(name, layout, dimensions = {})
          @name = name
          @layout = layout
          @dimensions = dimensions
          fail_dimensions unless dimensions_ok?
          @pending = []
          determine_dimensions
          finish_box
          layout.pending << name unless pending.empty?
        end

        def dimensions_ok?
          left_top = ['left', 'top'].all? { |s| dimensions.key? s }
          right_width = ['right', 'width'].any? { |s| dimensions.key? s }
          left_top and right_width
        end

        def fail_dimensions
          message = "For the selector #{name}, you failed to provide either " \
               'left, top, and width *or* left, top, and right. Instead you ' \
               "provided #{dimensions}."
          layout.give_up message
        end

        def determine_dimensions
          dimensions.each do |key, value|
            case value
            when String
              create_pending_dimension key, value
            when Numeric
              add_numeric_dimension key, value
            else
              puts "Warning, skipping #{key} in #{name}. Not sure why though :("
            end
          end
        end

        def finish_box
          right_width
          bottom_height
          styles
        end

        def right_width
          case
          when dimensions.key?('width')
            pending.include?('width') ? make_pending('right') : right_from_width
          when dimensions.key?('right')
            pending.include?('right') ? make_pending('width') : width_from_right
          end
        end

        def bottom_height
          case
          when dimensions.key?('height')
            pending.include?('height') ? make_pending('bottom') : bottom_from_height
          when dimensions.key?('bottom')
            pending.include?('bottom') ? make_pending('height') : height_from_bottom
          else
            @bottom = :none
            @height = :none
          end
        end

        def styles
          @styles = dimensions
          %w(top left right bottom width height).each do |dimension|
            @styles.delete dimension
          end
        end

        def make_pending(dimension)
          pair = dimension_pair dimension
          value = {pending: pair}
          instance_variable_set "@#{dimension}", value
        end

        def dimension_pair(dimension)
          case dimension
          when 'width'
            'right'
          when 'right'
            'width'
          when 'height'
            'bottom'
          when 'bottom'
            'height'
          end
        end

        def right_from_width
          @right = left + width
        end

        def width_from_right
          @width = right - left
        end

        def bottom_from_height
          @bottom = top - height
        end

        def height_from_bottom
          @height = top - bottom
        end

        def add_numeric_dimension(dimension_name, value)
          instance_variable_set "@#{dimension_name}", value
          layout.determined[dimension_name] = value
        end

        def create_pending_dimension(dimension_name, command_string)
          pending << dimension_name
          commands = command_array command_string
          pending = pending_hash commands
          return_hash = {pending: pending, command: commands}
          instance_variable_set "@#{dimension_name}", return_hash
        end

        def command_array(command_string)
          commands = command_string.split(' ')
          commands.map do |command|
            case command
            when '*', '+', '-', '/'
              command.to_sym
            when /\A\d+\Z/
              Float command
            else
              command
            end
          end
        end

        def pending_hash(command_array)
          h = {}
          command_array.each_with_index { |command, index| h[command] = index }
          h
        end

        def try_to_resolve
          pending.each do |dimension|
            hash = self.send dimension
            try_dimension(dimension, hash)
            if hash[:pending].empty? and safe?(hash[:command])
              command_string = hash[:command].join(' ')
              value = eval command_string
              instance_variable_set "@#{dimension}", value
            end
          end
        end

        def try_dimension(dimension_name, dimensions_hash)
          dimensions_hash[:pending].delete_if do |dimension_key, index|
            value = layout.determined[dimension_key]
            if value
              command_arr = dimensions_hash[:command]
              command_arr[index] = value
            end
          end
        end

        def safe?(command_array)
          command_array.all? do |elem|
            elem.is_a? Numeric or [:+, :-, :/, :*].include? elem
          end
        end

      end
    end
  end
end
