describe Bread::Basket::Poster::HeaderMaker do
  let(:pdf) { Prawn::Document.new }

  context 'when header styles are provided they override' do
    before(:all) do
      metadata = { 'stylesheet' => 'nearly_empty'  }
      Bread::Basket::Poster.dir_path = './spec/poster/test_files'
      @pdf = Prawn::Document.new
      @layout = Bread::Basket::Poster::Layout.new(metadata)
    end

    subject { Bread::Basket::Poster::HeaderMaker.new(pdf, @layout) }

    it "doesn't fail when #header selector is missing" do
      expect do
        subject.create_header('Header', 'font-size' => 12)
      end.not_to raise_error
    end
  end

  context 'when header styles are provided they override' do
    before(:all) do
      metadata = { 'stylesheet' => 'header_test'  }
      Bread::Basket::Poster.dir_path = './spec/poster/test_files'
      pdf = Prawn::Document.new
      layout = Bread::Basket::Poster::Layout.new(metadata)
      @header_maker = Bread::Basket::Poster::HeaderMaker.new(pdf, layout)
      styles = Bread::Basket::Poster.current_styles
      @header_maker.create_header('Header', styles)
    end

    subject { @header_maker.styles }

    its(['width']) { should eq(300) }
    its(['height']) { should eq(55) }

    its(['font-size']) { should eq(73) }
    its(['color']) { should eq('#cc00FF') }
    its(['margin-top']) { should eq(13) }
    its(['margin-bottom']) { should eq(17) }
    its(['radius']) { should eq(11) }
    its(['background-color']) { should eq('#000000') }
    its(['font-family']) { should eq('Courier') }
  end
end
