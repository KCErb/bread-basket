module Bread
  module Basket
    module Poster
      YAML_REGEX = /^(---\s*\n.*?\n?)^(---\s*$\n?)/m
      ERROR_MESSAGE = <<-EOS


      Your file must start with a YAML front matter.
      For example:
      ---
      layout: flow
      stylesheet: my_template
      ---

      EOS

      def self.create(file)
        parse file
        Layout.new(@metadata, @body)
      end

      def self.parse(filename)
        source = File.read(filename)
        matchdata = source.match(YAML_REGEX)

        if matchdata
          @metadata = YAML.load(matchdata[0])
          @body = matchdata.post_match
        else
          fail NoFrontMatterError, ERROR_MESSAGE
        end
      end
      # define custom error so that specs only pass if
      # error is caused by lack of front matter
      class NoFrontMatterError < StandardError; end
    end
  end
end
