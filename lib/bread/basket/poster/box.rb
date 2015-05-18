module Bread
  module Basket
    module Poster
      class Box
        include UnitsHelper
        # Box does most of the heavy lifting of the self-referential css
        # so it's a little confusing. It passes dimensions off to the dimensions
        # helper and holds the methods for setting dimensions as either pending
        # or determined and how to resolve those issues.
        attr_reader :selector_name, :method_name, :layout, :specs,
                    :pending, :unfinished, :styles
        attr_accessor :top, :left, :width, :height, :bottom, :right, :stretchy,
                      :content

        def initialize(name, layout, specs = {})
          fetch_names(name)
          @layout = layout
          @specs = specs
          @styles = specs
          @pending = []
          @unfinished = []

          setup_dimensions
          layout.image_boxes << method_name if self.is_a? ImageBox
          layout.boxes << selector_name
        end

        def fetch_names(name)
          @selector_name = name
          @method_name = name.sub('.', '').gsub('-', '_')
        end

        def setup_dimensions
          DimensionsHelper.new(self, layout, specs)
          layout.pending << selector_name unless pending.empty?
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
            if value && value != :stretchy
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
          str.strip
        end

        def stretchy?
          !stretchy.nil?
        end
      end
    end
  end
end
