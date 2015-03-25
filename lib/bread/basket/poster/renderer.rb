class Renderer < Redcarpet::Render::Base

  attr_reader :pdf, :layout

  def preprocess(full_document)
    # First things first
    @pdf = Bread::Basket::Poster::PDF
    @layout = Bread::Basket::Poster.layout
  end

  def postprocess(full_document)
    pdf.render_file "testerooony.pdf"
  end

  def metadata
    @metadata || {}
  end

  # plain jane text
  def paragraph(text)
    pdf.text text, inline_format: true
  end

  # sections
  def header(text,header_level)
    #needs to be scss aware
  end

  # figure with caption
  def block_code(caption, image_path)
    caption
  end

  # > A pull quote
  def block_quote(quote)
  end

  # *italic*
  def emphasis(text)
    "<i>#{text}</i>"
  end

  # **bold**
  def double_emphasis(text)
    "<b>#{text}</b>"
  end

  # _underline_
  def underline(text)
    "<u>#{text}</u>"
  end

  # super^script
  def superscript(text)
    "<sup>#{text}</sup>"
  end

  # code font
  def codespan(text)
    # needs to be scss aware
  end

  # accent color
  def highlight(text)
    # needs to be scss aware
  end

  # first thing called on each element, it's return
  # value gets added to the table row
  def table_cell(content,alignment)
  end

  # called after all cells, content is their contents joined
  def table_row(content)
  end

  # called after all rows, header is header row, body is remaining rows.
  def table(header, body)
  end
end
