describe Bread::Basket::Poster::CSSReader do
  context 'when given the test css' do
    let(:css) { File.expand_path('test_files/test.css') }
    let(:metadata) { { key: 'value'  } }
    let(:body) { 'Nom nom nom' }
    let(:layout) { Bread::Basket::Poster::Layout.new(metadata, body) }
    before(:each) do
      allow(layout).to receive(:flow?) { true }
    end

    subject { Bread::Basket::Poster::CSSReader.new(css, layout) }

    it 'turns rules into a hash with array of values' do
      expect(subject.rules_to_specs('key: value;')).to eq 'key' => 'value'
    end

    it 'turns number strings into numerics' do
      expect(subject.rules_to_specs('key: 12;')).to eq 'key' => 12
    end

    it 'turns number strings with units into numerics' do
      # 72 because it goes through prawn to do the conversion
      expect(subject.rules_to_specs('key: 1.in;')).to eq 'key' => 72
    end

    it "splits multiparameter fields nicely and doesn't try to eval them" do
      rule = 'key: bread - bite, bread + bite;'
      hash = { 'key' => ['bread - bite', 'bread + bite'] }
      expect(subject.rules_to_specs rule).to eq hash
    end
  end

  context 'when given a block css' do
    let(:block_file) { File.expand_path('./test_files/test_block.css') }
    subject { Bread::Basket::Poster::CSSReader.new(block_file, :block) }

    it 'fails if mismatch between css and layout type' do
      reader  = Bread::Basket::Poster::CSSReader.new(block_file, :flow)
      expect { reader.do_your_thing! }.to raise_error
    end
  end
end
