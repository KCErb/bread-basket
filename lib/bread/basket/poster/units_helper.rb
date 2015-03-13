module Bread
  module Basket
    module Poster
      module UnitsHelper
        # measurements get `eval`d so guard input! This list of options
        # comes from prawn/measurement_extensions
        MEASUREMENT_REGEX = /\A\d+\.(mm|cm|dm|m|in|yd|ft|pt)\z/
        NUMERIC_REGEX = /\A\d+(?:\.\d+)?\z/
        HASH_SELECTOR_REGEX = /\A#(\w+\-?)*\z/
        DIMENSIONS = %w(top left right bottom width height)

        def convert_units(value)
          case value
          when MEASUREMENT_REGEX
            eval(value)
          when NUMERIC_REGEX
            Float value
          else
            value.strip!
            convert_inner_units(value)
          end
        end

        def convert_inner_units(command_string)
          commands = command_string.split(' ')
          commands.map! do |command|
            if command =~ MEASUREMENT_REGEX
              eval(command)
            else
              command
            end
          end
          commands.join(' ')
        end
      end
    end
  end
end
