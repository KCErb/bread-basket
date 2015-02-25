describe Bread::Basket::Poster::Layout do
  def layout_obj(metadata)
    body = 'Hello :bread:'
    Bread::Basket::Poster::Layout.new(metadata, body)
  end

  context 'when metadata is meaningless' do
    let(:metadata) { { key: 'value' } }
    let(:body) { 'Hello :bread:!' }
    subject { Bread::Basket::Poster::Layout.new(metadata, body) }

    it 'has metadata' do
      expect(subject.metadata).to eq(metadata)
    end

    it 'has a body' do
      expect(subject.body).to eq(body)
    end

    it 'creates a css-reader' do
      expect(subject.css_reader).to be_a Bread::Basket::Poster::CSSReader
    end

    it 'defaults to flow template' do
      expect(subject.stylesheet).to eq('./samples/flow_sample.css')
    end
  end

  context 'for various values of metadata' do
    it 'uses the given stylesheet' do
      metadata = { 'stylesheet' => 'jellybeans.css' }
      subject = layout_obj(metadata)
      expect(subject.stylesheet).to eq('jellybeans.css')
    end

    it 'lays out a flow when layout is unrecognized' do
      metadata = { 'layout' => 'jellybean' }
      subject = layout_obj(metadata)
      expect(subject.layout).to eq(:flow)
    end

    it 'lays out a flow when layout is nil' do
      metadata = {}
      subject = layout_obj(metadata)
      expect(subject.layout).to eq(:flow)
    end
  end

  context 'when layout is flow' do
    let(:metadata) { { 'layout' => 'flow' } }
    subject { layout_obj(metadata) }

    it 'lays out a flow' do
      expect(subject.layout).to eq(:flow)
    end

    it 'knows that flows flow' do
      expect(subject.flow?).to eql(true)
    end
  end

  context 'when layout is block' do
    let(:metadata) { { 'layout' => 'block' } }
    subject { layout_obj(metadata) }

    it 'lays out a block' do
      expect(subject.layout).to eq(:block)
    end

    it "knows that blocks don't flow" do
      expect(subject.flow?).to eq(false)
    end
  end
end
