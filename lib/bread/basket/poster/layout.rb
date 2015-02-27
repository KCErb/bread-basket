module Bread
  module Basket
    module Poster
      class Layout
        attr_reader :metadata, :body, :stylesheet, :css_reader, :layout

        def initialize(metadata, body)
          @metadata = metadata
          @body = body
          @layout = determine_layout
          @stylesheet = find_stylesheet(metadata['stylesheet'])
          @css_reader = CSSReader.new(stylesheet, layout)
          create_document
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

        def create_document
          css_reader.parse!
        end

        def handle_else(layout)
          if layout
            puts "Unrecognized layout `#{layout}`, using flow instead"
          else
            puts "No layout specified;\ndefaulting to flow."
          end
        end
      end
    end
  end
end
