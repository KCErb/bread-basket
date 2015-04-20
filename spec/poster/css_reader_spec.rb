describe Bread::Basket::Poster::CSSReader do
  # This will actually run through all kinds of boxes, dimensions helpers
  # and the like, but I'm trying to only spec out the jobs of css_reader.
  context 'when given the basic_flow stylesheet' do
    # Using a before block here because I want to alter the load path without
    # actually loading a markdown file from the start. Layout needs a real css
    # file to talk to in order to initialize correctly.
    before(:all) do
      metadata = { 'stylesheet' => 'basic_flow'  }
      Bread::Basket::Poster.dir_path = './spec/poster/test_files'
      @layout = Bread::Basket::Poster::Layout.new(metadata)
    end

    describe 'css_reader sets up the layout properties' do
      subject { @layout }
      its(:top)    { should eq(720) }
      its(:bottom) { should eq(0) }
      its(:height) { should eq(720) }
      its(:left)   { should eq(0) }
      its(:right)  { should eq(1080) }
      its(:width)  { should eq(1080) }

      its(:font_size)  { should eq(24) }
      its(:font_family)  { should eq('times') }
      its(:boxes) do
        boxes = %w(columns[0] columns[1] columns[2] columns[3] .stretchy-box .image)
        should eq boxes
      end
    end

    describe 'css_reader sets up columns[0]' do
      subject { @layout.columns[0] }
      its(:top)    { should eq(648) }
      its(:bottom) { should eq(5) }
      its(:height) { should eq(643) }
      its(:left)   { should eq(5) }
      its(:right)  { should eq(254.5) }
      its(:width)  { should eq(249.5) }
    end

    describe 'css_reader sets up columns[1]' do
      subject { @layout.columns[1] }
      its(:top)    { should eq(576) }
      its(:bottom) { should eq(5) }
      its(:height) { should eq(571) }
      its(:left)   { should eq(278.5) }
      its(:right)  { should eq(528) }
      its(:width)  { should eq(249.5) }
    end

    describe 'css_reader sets up the bounds for stretchy box' do
      subject { @layout.stretchy_box }
      its(:top)    { should eq(100) }
      its(:bottom) { should eq(:stretchy) }
      its(:height) { should eq(:stretchy) }
      its(:left)   { should eq(200) }
      its(:right)  { should eq(700) }
      its(:width)  { should eq(500) }
      it 'has font-size style' do
        font_size = subject.styles['font-size']
        expect(font_size).to eq 22
      end
    end

    describe 'css_reader sets up the bounds for image' do
      subject { @layout.image }
      its(:top)    { should eq(720) }
      its(:bottom) { should eq(308) }
      its(:height) { should eq(412) }
      its(:left)   { should eq(576) }
      its(:right)  { should eq(1080) }
      its(:width)  { should eq(504) }
    end

    describe 'css_reader creates header style' do
      subject { @layout.header }
      it 'should have background color in its hash' do
        expect(subject['background-color']).to eq('#ffffff')
      end
    end

    describe "css_reader's other functions" do
      subject { @layout.css_reader }

      it 'convert string css rules string into hash of strings' do
        css_rules = 'bread: howdy; basket: belly'
        specs_hash = { 'bread' => 'howdy', 'basket' => 'belly' }
        expect(subject.rules_to_specs(css_rules)).to eq specs_hash
      end

      it 'convert css rules with commas into hash of arrays' do
        css_rules = 'bread: howdy, belly'
        specs_hash = { 'bread' => %w(howdy belly) }
        expect(subject.rules_to_specs(css_rules)).to eq specs_hash
      end

      it 'convert selector names into valid ruby names' do
        selector_name = '#a-nice-name.'
        method_name = 'a_nice_name'
        expect(subject.to_method_name(selector_name)).to eq method_name
      end
    end
  end

  context 'when given the basic_block stylesheet' do
    it 'fails if mismatch between css and layout type' do
      metadata = { 'stylesheet' => 'basic_block', 'layout' => 'flow'  }
      Bread::Basket::Poster.dir_path = './spec/poster/test_files'

      expect do
        Bread::Basket::Poster::Layout.new(metadata)
      end.to raise_error SystemExit
    end
  end
end
