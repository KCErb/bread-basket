module Bread
  module Basket
    module Poster
      class Layout
        attr_reader :metadata, :body, :stylesheet, :css_reader, :layout

        def initialize(metadata, body)
          @metadata = metadata
          @body = body
          @layout = determine_layout
          @stylesheet = metadata['stylesheet'] || template
          @css_reader = CSSReader.new(stylesheet)
          puts @css_reader.inspect if @css_reader.nil?
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

        def flow?
          layout == :flow
        end

        def template
          template = './samples/block_sample.css'
          template = './samples/flow_sample.css' if flow?
          template
        end

        def create_document
          css_reader.parse(stylesheet)
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
