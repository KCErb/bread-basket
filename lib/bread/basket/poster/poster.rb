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
        case @metadata['layout']
        when 'flow'
          FlowLayout.new(@metadata, @body)
        when 'block'
          BlockLayout.new(@metadata, @body)
        else
          handle_else @metadata['layout']
        end
      end

      def self.handle_else(layout)
        if layout
          puts "Unrecognized layout `#{layout}`, using flow instead"
          FlowLayout.new(@metadata, @body)
        else
          puts "No layout specified;\ndefaulting to flow."
          FlowLayout.new(@metadata, @body)
        end
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
