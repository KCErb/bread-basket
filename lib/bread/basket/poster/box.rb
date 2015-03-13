module Bread
  module Basket
    module Poster
      class Box
        include UnitsHelper
        # Box does most of the heavy lifting of the self-referential css
        # so it's a little confusing. I'm planning to write up an explanation
        # on the wiki.
        attr_reader :selector_name, :method_name, :layout, :specs, :top, :left,
                    :width, :height, :bottom, :right, :pending, :unfinished

        def initialize(name, layout, specs = {})
          @selector_name = name
          @method_name = name.sub('.', '').sub('-', '_')
          @layout = layout
          @specs = specs
          @pending = []
          @unfinished = []

          setup_dimensions
          setup_styles
        end

        def setup_dimensions
          DimensionsHelper.new(self, layout, specs)
          layout.pending << selector_name unless pending.empty?
        end

        def setup_styles
          @styles = specs
          DIMENSIONS.each do |dimension|
            @styles.delete dimension
          end
        end

        def try_to_resolve
          pending.each do |dimension|
            hash = send dimension
            try_dimension hash
            resolve_dimension(dimension, hash) if ready_to_resolve? hash
          end
        end

        def try_dimension(dimensions_hash)
          dimensions_hash[:pending].delete_if do |dimension_key, index|
            value = layout.determined[dimension_key]
            if value
              command_arr = dimensions_hash[:command]
              command_arr[index] = value
            end
          end
        end

        def resolve_dimension(dimension, hash)
          command_string = hash[:command].join(' ')
          value = eval command_string
          instance_variable_set "@#{dimension}", value
          pending.delete dimension
          add_to_determined dimension, value
          resolve_box if pending.empty?
        end

        def ready_to_resolve?(hash)
          hash[:pending].empty? && safe?(hash[:command])
        end

        def safe?(command_array)
          command_array.all? do |elem|
            (elem.is_a? Numeric) || ([:+, :-, :/, :*, '(', ')'].include?(elem))
          end
        end

        def add_to_determined(dimension_name, value)
          name = method_name + '.' + dimension_name
          instance_variable_set "@#{dimension_name}", value
          layout.determined[name] = value
        end

        def resolve_box
          layout.pending.delete selector_name
          unfinished.each { |dimension| determine_missing dimension }
        end
        # Rubocop hates determine_missing
        # rubocop:disable all
        def determine_missing(missing_dimension)
          value = case missing_dimension
                  when 'left'
                    right - width
                  when 'right'
                    left + width
                  when 'width'
                    right - left
                  when 'top'
                    bottom + height
                  when 'height'
                    top - bottom
                  when 'bottom'
                    top - height
                  end
          add_to_determined missing_dimension, value
        end
        # rubocop:enable all
        def inspect
          str = ''
          %w(top left width height bottom right).each do |dim|
            str << "#{dim}: #{send(dim)}; "
          end
          str
        end
      end
    end
  end
end
