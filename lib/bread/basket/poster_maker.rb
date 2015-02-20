module Bread
  module Basket
    class PosterMaker
      attr_reader :metadata

      def initialize(filename)
        @metadata = extract_yaml(filename)
      end

      def extract_yaml(filename)
        source = File.read(filename)
        raw_metadata = source.match(/^(---\s*\n.*?\n?)^(---\s*$\n?)/m)

        if raw_metadata
          parsed_metadata = YAML.load(raw_metadata[0])
        else
          fail NoMetadataError, METADATA_ERROR
        end
        parsed_metadata
      end

      METADATA_ERROR = <<-EOS


      Your file must start with some metadata.
      For example:
      ---
      stylesheet: 'template.css'
      ---

      EOS
    end
    # define custom error so that specs only pass if
    # error is caused by lack of metadata
    class NoMetadataError < StandardError; end
  end
end
