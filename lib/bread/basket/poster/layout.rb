module Bread
  module Basket
    module Poster
      class Layout
        attr_reader :metadata, :body, :stylesheet, :css_reader, :layout
        attr_accessor :height, :width, :left, :right, :top, :bottom, :margin,
                      :pending, :determined, :font_size, :font_family

        def initialize(metadata, body)
          @metadata = metadata
          @body = body
          @layout = determine_layout
          @stylesheet = find_stylesheet(metadata['stylesheet'])
          @css_reader = CSSReader.new(stylesheet, self)
          css_reader.do_your_thing!
        end

        def determine_layout
          case @metadata['layout']
          when 'block'
            layout = :block
          when 'flow'
            layout = :flow
          else
            handle_else @metadata['layout']
            layout = :flow
          end
          layout
        end

        def find_stylesheet(stylesheet_name)
          if stylesheet_name
            Bread::Basket::Poster.dirpath + '/' + stylesheet_name + '.css'
          else
            template
          end
        end

        def flow?
          layout == :flow
        end

        def template
          template = File.expand_path('./samples/block_sample.css')
          template = File.expand_path('./samples/flow_sample.css') if flow?
          template
        end

        def handle_else(layout)
          if layout
            puts "Unrecognized layout `#{layout}`, using flow instead"
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
          @pending = []
          @determined = {}
          @font_size ||= 36.0
          @font_family ||= 'Helvetica'
          # add dimensions to the determined hash for reference
          %w(width height left right top bottom margin).each do |method_name|
            determined[method_name] = eval("@#{method_name}")
          end
        end

        def try_to_resolve_pendings
          pending.reverse_each do |name|
            # very limited match on columns for now
            match = name.match(/columns\[(\d)\]/)
            if match
              index = match[1].to_i
              columns[index].try_to_resolve
            else
              box = send name.sub('.', '').sub('-', '_')
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
