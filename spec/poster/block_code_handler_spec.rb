describe Bread::Basket::Poster::BlockCodeHandler do
  let(:pdf) { Prawn::Document.new }
  let(:first_line) { 'dragon.png' }
  let(:content) { "Here's a *caption* with **markdown**" }
  # explanation of before(:all) in css_reader_spec
  context 'when used to create images' do
    before(:each) do
      metadata = { 'stylesheet' => 'block_code_test'  }
      Bread::Basket::Poster.dir_path = './spec/poster/test_files'
      @layout = Bread::Basket::Poster::Layout.new(metadata)
      Bread::Basket::Poster.layout = @layout
      Bread::Basket::Poster.pdf = pdf
    end

    subject do
      Bread::Basket::Poster::BlockCodeHandler.new(pdf, @layout, first_line, content)
    end

    # yeah sorta bare bones here, open to suggestions
    it 'doesnt fail' do
      subject
    end
  end
end
