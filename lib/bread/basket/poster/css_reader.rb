module Bread
  module Basket
    module Poster
      class CSSReader
        include CssParser
        include UnitsHelper
        attr_reader :parser, :layout

        COLUMNS_FAIL = 'To use a flow layout your stylesheet must include ' \
                       '.columns selector.'
        LAYOUT_FAIL = 'Your stylesheet must include the .layout selector.'

        def initialize(stylesheet_path, layout)
          @layout = layout
          @parser = CssParser::Parser.new
          @parser.load_file!(stylesheet_path)
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
          attributes_from_specs(specs)
          finish_layout_box
        end

        def attributes_from_specs(specs)
          layout.width = specs.delete 'width'
          layout.height = specs.delete 'height'
          layout.margin = specs.delete 'margin' || 0
          specs.each do |k, v|
            layout.create_attribute(k, v)
          end
        end

        def finish_layout_box
          layout.left = 0
          layout.right = layout.width
          layout.bottom = 0
          layout.top = layout.height
        end

        def create_columns
          columns = parser.find_by_selector '.columns'
          layout.give_up COLUMNS_FAIL if columns.empty?
          specs = rules_to_specs(columns[0])
          columns = Columns.new specs, layout
          layout.create_attribute('columns', columns.boxes)
        end

        def create_bounding_boxes
          parser.each_selector do |selector, declarations|
            next if skip_selector? selector
            method_name = to_method_name selector
            specs = rules_to_specs declarations
            box = create_box selector, layout, specs
            layout.create_attribute(method_name, box)
          end
        end

        def skip_selector?(selector)
          old_selector = %w(.layout .columns).include? selector
          hash_selector = selector =~ HASH_SELECTOR_REGEX
          old_selector || hash_selector
        end

        def create_box(selector, layout, specs)
          if specs.key?('src')
            ImageBox.new selector, layout, specs
          else
            Box.new selector, layout, specs
          end
        end

        def create_styles
          parser.each_selector do |selector, declarations|
            next unless selector =~ HASH_SELECTOR_REGEX
            method_name = to_method_name selector
            specs = rules_to_specs declarations
            layout.create_attribute(method_name, specs)
          end
        end

        def rules_to_specs(css_rules)
          # rule => "top: title.bottom, authors.bottom"
          # spec => { top: ['title.bottom', 'authors.bottom'] }
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
          value_arr.map!(&:strip)
          hash[key] = value_arr
        end

        def to_method_name(hash_selector)
          hash_selector.sub('#', '').sub('.', '').sub('-', '_')
        end
      end
    end
  end
end
