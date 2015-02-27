module Bread
  module Basket
    module Poster
      class CSSReader
        include CssParser
        attr_reader :parser, :layout

        COLUMNS_FAIL = 'To use a flow layout your stylesheet must include ' \
                       '.columns selector.'
        # measurements get `eval`d so guard input! This list of options
        # comes from prawn/measurement_extensions
        MEASUREMENT_REGEX = /\d+\.(mm|cm|dm|m|in|yd|ft|pt)/
        NUMERIC_REGEX = /\A\d+\Z/

        def initialize(stylesheet, layout)
          @layout = layout
          @parser = CssParser::Parser.new
          @parser.load_file!(stylesheet)
        end

        def parse!
          create_columns! if layout == :flow
          # create_boxes
          # create_styles
        end

        def create_columns!
          columns = parser.find_by_selector '.columns'
          fail COLUMNS_FAIL unless columns
          specs = rules_to_specs(columns[0])
          @columns = Columns.new specs
        end

        def rules_to_specs(css_rules)
          rules_arr = css_rules.split(';')
          hash = {}

          rules_arr.each { |rule| rule_to_hash(rule, hash) }

          hash.each_with_object({}) do |(k, v), h|
            h[k] = v.map { |value| convert_units(value) }
          end
        end

        def rule_to_hash(rule, hash)
          rule_arr = rule.split(':')
          key = rule_arr[0].strip
          value_arr = rule_arr[1].strip.split(',')
          hash[key] = value_arr
        end

        def convert_units(value)
          case value
          when MEASUREMENT_REGEX
            eval(value)
          when NUMERIC_REGEX
            Float value
          else
            value.strip
          end
        end
      end
    end
  end
end
