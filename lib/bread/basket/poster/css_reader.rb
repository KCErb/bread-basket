module Bread
  module Basket
    module Poster
      class CSSReader
        include CssParser
        attr_reader :parser

        def initialize(stylesheet)
          @parser = CssParser::Parser.new
          parser.load_file!(stylesheet)
        end

        def parse(stylesheet)
          puts "parsing #{stylesheet}"
          # create_columns! if flow?
          # create_boxes
          # create_styles
        end
      end
    end
  end
end
