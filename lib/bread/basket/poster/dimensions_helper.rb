module Bread
  module Basket
    module Poster
      class DimensionsHelper
        # Dimensions Helper checks the dimensions and determines how to handle
        # them (pending vs numeric)
        include UnitsHelper
        attr_reader :box, :layout, :dimensions, :checker

        def initialize(box, layout, dimensions)
          @layout = layout
          @box = box
          @dimensions = dimensions
          @checker = BoxChecker.new box, dimensions
          fail_dimensions unless checker.box_ok?
          determine_dimensions
          box.try_to_resolve
          frame_box
        end

        def fail_dimensions
          message = "For the selector #{box.selector_name}, you failed to " \
          'provide enough dimensions to draw a box. You need two of these three: ' \
          'left, right, width; and either `top` or `bottom and height`. Instead you ' \
          "provided #{dimensions}."
          layout.give_up message
        end

        def determine_dimensions
          dimensions.each do |key, value|
            next unless DIMENSIONS.include? key
            case value
            when String
              create_pending_dimension key, value
            when Numeric
              add_numeric_dimension key, value
            end
          end
        end

        def add_numeric_dimension(dimension_name, value)
          box.instance_variable_set "@#{dimension_name}", value
          box.add_to_determined(dimension_name, value)
        end

        def create_pending_dimension(dimension_name, command_string)
          box.pending << dimension_name
          commands = command_array command_string
          pending = create_pending_hash commands
          return_hash = { pending: pending, command: commands }
          box.instance_variable_set "@#{dimension_name}", return_hash
        end

        def command_array(command_string)
          commands = command_string.split(' ')
          commands.map { |command| convert_command(command) }
        end

        def convert_command(command)
          case command
          when '*', '+', '-', '/'
            command.to_sym
          when layout.css_reader.class::NUMERIC_REGEX
            Float command
          else
            command.gsub('-', '_')
          end
        end

        def create_pending_hash(command_array)
          h = {}
          command_array.each_with_index do |command, index|
            if (command.is_a? String) && (command != '(') && (command != ')')
              h[command] = index
            end
          end
          h
        end

        def frame_box
          # from two of left, right, width, determine other dimension
          # bottom, height are optional unless top is missing
          left_right_width
          top_bottom_height
        end

        def left_right_width
          given = checker.horizontal_dimensions
          difference = %w(left right width) - given
          missing = difference.empty? ? 'right' : difference[0]
          missing_dimension given, missing
        end

        def top_bottom_height
          given = checker.vertical_dimensions
          difference = %w(top bottom height) - given
          case difference.length
          when 0
            missing_dimension given, 'bottom'
          when 1
            missing_dimension given, difference[0]
          when 2
            make_stretchy
          end
        end

        def missing_dimension(given, missing)
          if given.any? { |dim| box.pending.include? dim }
            box.unfinished << missing
          else
            box.determine_missing missing
          end
        end

        def make_stretchy
          box.add_to_determined 'bottom', :stretchy
          box.add_to_determined 'height', :stretchy
        end
      end
    end
  end
end
