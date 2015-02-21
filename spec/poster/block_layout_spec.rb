describe Bread::Basket::Poster::BlockLayout do
  let(:metadata) { { key: 'value' } }
  let(:body) { 'Hello :bread:!' }
  subject { Bread::Basket::Poster::BlockLayout.new(metadata, body) }

  it 'has metadata' do
    expect(subject.metadata).to eq(metadata)
  end

  it 'has a body' do
    expect(subject.body).to eq(body)
  end
end
