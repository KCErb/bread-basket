module Bread
  module Basket
    module Poster
      class PosterMaker
        YAML_REGEX = /^(---\s*\n.*?\n?)^(---\s*$\n?)/m
        ERROR_MESSAGE = <<-EOS


        Your file must start with a YAML front matter.
        For example:
        ---
        layout: flow
        stylesheet: my_template
        ---

        EOS

        attr_accessor :layout

        def initialize(filename)
          @filename = filename
          filepath = File.expand_path(filename)
          Poster.dir_path = File.dirname(filepath)
          check_file
          create_layout
        end

        def check_file
          source = File.read(@filename)
          @matchdata = source.match(YAML_REGEX)
          fail NoFrontMatterError, ERROR_MESSAGE unless @matchdata
        end

        def create_layout
          @metadata = YAML.load(@matchdata[0])
          @body = @matchdata.post_match
          @layout = Layout.new(@metadata, @body)
        end
      end

      # define custom error so that specs only pass if
      # error is caused by lack of front matter
      class NoFrontMatterError < StandardError; end
    end
  end
end
