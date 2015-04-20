module Prawn
  class Document
    class ColumnBox < BoundingBox
      # :nocov:
      # Not testing this because I can't figure out how to do it :(
      # so be sure to look at samples to make sure column tops are correct
      def move_past_bottom
        @current_column = (@current_column + 1) % @columns
        column = ::Bread::Basket::Poster.layout.columns[@current_column]
        @document.y = column.top
        @document.start_new_page if @current_column == 0
        @y = @parent.absolute_top if @reflow_margins && (@current_column == 0)
      end
      # :nocov:
    end
  end
end
