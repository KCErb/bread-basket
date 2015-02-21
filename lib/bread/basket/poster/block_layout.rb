module Bread
  module Basket
    module Poster
      class BlockLayout
        attr_reader :metadata, :body

        def initialize(metadata, body)
          @metadata = metadata
          @body = body
        end
      end
    end
  end
end
