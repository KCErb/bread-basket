describe Bread::Basket::Poster::CSSReader do
  context 'when given a flow css' do
    let(:flow_file) { File.expand_path('./samples/flow_sample.css') }
    # TODO: There's got to be a nicer way to give layout to subject
    # I don't think I want to spin up a whole Layout instance though
    let(:layout) { double }
    before(:each) do
      allow(layout).to receive(:flow?) { true }
    end

    subject { Bread::Basket::Poster::CSSReader.new(flow_file, layout) }

    it 'turns rules into a hash with array of values' do
      expect(subject.rules_to_specs('key: value;')).to eq 'key' => ['value']
    end

    it 'turns number strings into numerics' do
      expect(subject.rules_to_specs('key: 12;')).to eq 'key' => [12]
    end

    it 'turns number strings with units into numerics' do
      # 72 because it goes through prawn to do the conversion
      expect(subject.rules_to_specs('key: 1.in;')).to eq 'key' => [72]
    end

    it "splits multiparameter fields nicely and doesn't try to eval them" do
      rule = 'key: bread - bite, bread + bite;'
      hash = { 'key' => ['bread - bite', 'bread + bite'] }
      expect(subject.rules_to_specs rule).to eq hash
    end

    it 'creates a Columns object' do
      expect(Bread::Basket::Poster::Columns).to receive(:new)
      subject.do_your_thing!
    end
  end

  context 'when given a block css' do
    let(:block_file) { File.expand_path('./samples/block_sample.css') }
    subject { Bread::Basket::Poster::CSSReader.new(block_file, :block) }

    it 'fails if mismatch between css and layout type' do
      reader  = Bread::Basket::Poster::CSSReader.new(block_file, :flow)
      expect { reader.do_your_thing! }.to raise_error
    end
  end
end
