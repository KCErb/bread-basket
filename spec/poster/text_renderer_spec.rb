describe Bread::Basket::Poster::TextRenderer do
  subject { Bread::Basket::Poster::TextRenderer.new }
  let(:layout) { double('layout') }
  before do
    subject.instance_variable_set(:@curr_styles, {})
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
    subject.instance_variable_set(:@layout, layout)
    parsed_string = subject.highlight('howdy')
    expect(parsed_string).to eq "<color rgb='006eff'>howdy</color>"
  end
end
