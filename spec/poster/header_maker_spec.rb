describe Bread::Basket::Poster::HeaderMaker do
  let(:pdf) {  Prawn::Document.new }
  # explanation of before(:all) in css_reader_spec
  context 'when header selector is missing' do
    let(:metadata) { { 'stylesheet' => 'nearly_empty'  } }
    let(:layout) { Bread::Basket::Poster::Layout.new(metadata) }

    before(:each) do
      Bread::Basket::Poster.dir_path = './spec/poster/test_files'
    end

    subject { Bread::Basket::Poster::HeaderMaker.new(pdf, layout) }

    it "doesn't fail" do
      expect do
        subject.create_header('Header', 'font-size' => 12)
      end.not_to raise_error
    end

    it 'returns layout styles as empty hash' do
      expect(subject.layout_styles).to eq({})
    end
  end

  context 'when header styles are provided they override' do
    let(:metadata) { { 'stylesheet' => 'header_test'  } }
    let(:layout) { Bread::Basket::Poster::Layout.new(metadata) }
    let(:header_maker) { Bread::Basket::Poster::HeaderMaker.new(pdf, layout) }

    before(:each) do
      Bread::Basket::Poster.dir_path = './spec/poster/test_files'
      styles = Bread::Basket::Poster.current_styles
      header_maker.create_header('Header', styles)
    end

    subject { header_maker.styles }

    its(['width'])  { should eq(300) }
    its(['height']) { should eq(55) }

    its(['font-size'])        { should eq(73) }
    its(['color'])            { should eq('#cc00FF') }
    its(['margin-top'])       { should eq(13) }
    its(['margin-bottom'])    { should eq(17) }
    its(['radius'])           { should eq(11) }
    its(['background-color']) { should eq('#000000') }
    its(['font-family'])      { should eq('Courier') }
  end
end
