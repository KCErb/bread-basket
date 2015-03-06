module Bread
  module Basket
    module Poster
      class CSSReader
        include CssParser
        attr_reader :parser, :layout

        COLUMNS_FAIL = 'To use a flow layout your stylesheet must include ' \
                       '.columns selector.'
        LAYOUT_FAIL = 'Your stylesheet must include the .layout selector.'
        # measurements get `eval`d so guard input! This list of options
        # comes from prawn/measurement_extensions
        MEASUREMENT_REGEX = /\A\d+\.(mm|cm|dm|m|in|yd|ft|pt)\z/
        NUMERIC_REGEX = /\A\d+(?:\.\d+)?\z/
        HASH_SELECTOR_REGEX = /\A#(\w+\-?)*\z/

        def initialize(stylesheet, layout)
          @layout = layout
          @parser = CssParser::Parser.new
          @parser.load_file!(stylesheet)
        end

        def do_your_thing!
          init_layout
          create_columns if layout.flow?
          create_bounding_boxes
          create_styles
        end

        def init_layout
          layout_rules = parser.find_by_selector '.layout'
          layout.give_up LAYOUT_FAIL if layout_rules.empty?
          specs = rules_to_specs(layout_rules[0])
          create_layout_attributes(specs)
          layout.handle_defaults
        end

        def create_layout_attributes(specs)
          layout.width = specs.delete 'width'
          layout.height = specs.delete 'height'
          layout.margin = specs.delete 'margin' || 0
          specs.each do |k, v|
            layout.create_attribute(k, v)
          end
        end

        def create_columns
          columns = parser.find_by_selector '.columns'
          layout.give_up COLUMNS_FAIL if columns.empty?
          specs = rules_to_specs(columns[0])
          columns = Columns.new specs, layout
          layout.create_attribute('columns',columns.boxes)
        end

        def create_bounding_boxes
          parser.each_selector do |selector, declarations|
            next if %w(.layout .columns).include? selector
            next if selector =~ HASH_SELECTOR_REGEX
            method_name = to_method_name selector
            specs = rules_to_specs declarations
            box = Box.new selector, layout, specs
            layout.create_attribute(method_name, box)
            try_to_resolve_pendings
          end
          #pending is -1, so need one more to finish
          try_to_resolve_pendings
        end

        def create_styles
          parser.each_selector do |selector, declarations|
            next unless selector =~ HASH_SELECTOR_REGEX
            method_name = to_method_name selector
            specs = rules_to_specs declarations
            layout.create_attribute(method_name, specs)
          end
        end

        def try_to_resolve_pendings
          layout.pending.each do |name|
            # very limited match on columns for now
            match = name.match /columns\[(\d)\]/
            if match
              col_arr = layout.send 'columns'
              index = match[1].to_i
              col_arr[index].try_to_resolve
            else
              box = layout.send to_method_name(name)
              box.try_to_resolve
            end
          end
        end

        def to_method_name(name)
          name.sub('.','').sub('-','_').sub('#','')
        end

        def rules_to_specs(css_rules)
          rules_arr = css_rules.split(';')
          hash = {}

          rules_arr.each { |rule| rule_to_hash(rule, hash) }

          hash.each_with_object({}) do |(k, v), h|
            arr = v.map { |value| convert_units(value) }
            h[k] = arr.length == 1 ? arr[0] : arr
          end
        end

        def rule_to_hash(rule, hash)
          rule_arr = rule.split(':')
          key = rule_arr[0].strip
          value_arr = rule_arr[1].strip.split(',')
          value_arr.map!{ |e| e.strip }
          hash[key] = value_arr
        end

        def convert_units(value)
          case value
          when MEASUREMENT_REGEX
            eval(value)
          when NUMERIC_REGEX
            Float value
          else
            value.strip!
            new_value = convert_inner_units(value)
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
