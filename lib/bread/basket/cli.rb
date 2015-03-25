module Bread
  module Basket
    class Cli < Thor
      desc 'poster FILENAME', 'Creates a scientific poster from FILENAME'
      def poster(file)
        Bread::Basket::Poster::PosterMaker.new(file)
      end
    end
  end
end
