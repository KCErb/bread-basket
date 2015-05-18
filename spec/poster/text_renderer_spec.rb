describe Bread::Basket::Poster::TextRenderer do
  subject { Bread::Basket::Poster::TextRenderer.new }
  let(:layout) { double('layout') }
  let(:pdf) { double('pdf') }

  before do
    subject.instance_variable_set(:@curr_styles, {})
    subject.instance_variable_set(:@pdf, pdf)
    subject.instance_variable_set(:@layout, layout)
  end

  it 'emphasises text correctly' do
    parsed_string = subject.emphasis('howdy')
    expect(parsed_string).to eq '<i>howdy</i>'
  end

  it 'bolds text correctly' do
    parsed_string = subject.double_emphasis('howdy')
    expect(parsed_string).to eq '<b>howdy</b>'
  end

  it 'underlines text correctly' do
    parsed_string = subject.underline('howdy')
    expect(parsed_string).to eq '<u>howdy</u>'
  end

  it 'super scripts correctly' do
    parsed_string = subject.superscript('howdy')
    expect(parsed_string).to eq '<sup>howdy</sup>'
  end

  it 'uses default highlight color when none given' do
    parsed_string = subject.highlight('howdy')
    expect(parsed_string).to eq "<color rgb='f700ff'>howdy</color>"
  end

  it "uses given highlight color when it's given" do
    allow(layout).to receive(:highlight).and_return('color' => '#006eff')
    parsed_string = subject.highlight('howdy')
    expect(parsed_string).to eq "<color rgb='006eff'>howdy</color>"
  end

  it 'hands header work off to the HeaderMaker class' do
    header_maker = double(Bread::Basket::Poster::HeaderMaker)
    expect(header_maker).to receive(:create_header)
    subject.instance_variable_set(:@header_maker, header_maker)
    subject.header('# Title', 3)
  end

  it 'hands block code work off to the BlockCodeHandler class' do
    expect(Bread::Basket::Poster::BlockCodeHandler).to receive(:new)
    subject.block_code('content', 'first line')
  end
end
