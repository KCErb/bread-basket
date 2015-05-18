module Bread
  module Basket
    module Poster
      class Layout
        attr_reader :metadata, :stylesheet, :css_reader, :type
        attr_accessor :height, :width, :left, :right, :top, :bottom, :margin,
                      :pending, :determined, :font_size, :font_family, :boxes,
                      :image_boxes

        def initialize(metadata)
          @metadata = metadata
          @type = determine_type
          @stylesheet = find_stylesheet(metadata['stylesheet'])
          @css_reader = CSSReader.new(stylesheet, self)
          css_reader.do_your_thing!
        end

        def determine_type
          case @metadata['layout']
          when 'block'
            :block
          when 'flow'
            :flow
          else
            handle_else @metadata['layout']
            :flow
          end
        end

        def find_stylesheet(stylesheet_name)
          if stylesheet_name
            path = Bread::Basket::Poster.dir_path + '/' + stylesheet_name
            path += '.css' unless stylesheet_name.include?('.css')
            path
          else
            puts 'Warning: no stylesheet given, using template instead.'
            template
          end
        end

        def flow?
          type == :flow
        end

        def template
          template = File.expand_path('./samples/block_sample.css')
          template = File.expand_path('./samples/flow_sample.css') if flow?
          template
        end

        def handle_else(layout)
          if layout
            puts "Warning: Unrecognized layout `#{layout}`, using flow instead"
          else
            puts 'Warning: No layout specified, defaulting to flow.'
          end
        end

        def create_attribute(key, value)
          new_key = key.gsub('-', '_').sub('.', '').to_sym
          self.class.send(:define_method, new_key) do
            value
          end
          # This is called at end of each attribute's definition
          try_to_resolve_pendings unless pending.nil?
        end

        def handle_defaults
          empty_defaults
          @font_size ||= 36
          @font_family ||= 'Helvetica'
          @margin ||= 36
          # add dimensions to the determined hash for reference
          # open to a better solution here :)
          %w(width height left right top bottom margin font_size
             font_family).each do |method_name|
            determined[method_name] = eval("@#{method_name}")
          end
        end

        def empty_defaults
          @pending = []
          @determined = {}
          @boxes = []
          @image_boxes = []
        end

        def try_to_resolve_pendings
          pending.reverse_each do |name|
            # very limited match on columns for now
            match = name.match(/columns\[(\d)\]/)
            if match
              index = match[1].to_i
              columns[index].try_to_resolve
            else
              box = send name.sub('.', '').gsub('-', '_')
              box.try_to_resolve
            end
          end
        end

        def give_up(message)
          puts '== Aborting =='
          puts message
          exit
        end
      end
    end
  end
end
