describe Bread::Basket::Poster::Box do
  # explanation of before all in css_reader_spec
  before(:all) do
    metadata = { 'stylesheet' => 'self_referential'  }
    body = 'Nom nom nom'
    Bread::Basket::Poster.dir_path = './spec/poster/test_files'
    @name = '.simple-selector'
    @layout = Bread::Basket::Poster::Layout.new(metadata, body)
  end

  describe 'css_reader sets up columns[0] correctly via reference' do
    subject { @layout.columns[0] }
    its(:top)    { should eq(500) }
    its(:height) { should eq(495) }
  end

  describe 'css_reader leaves columns[1] pending due to stretchy dependence' do
    subject { @layout.columns[1] }
    its(:top)  do
      # There are a few things hiding here, it converts the command name from - to _
      # and it correctly inserts margin as 5.0
      h = { pending: { 'stretchy_box.bottom' => 0 },
            command: ['stretchy_box.bottom', :-, 5.0]
          }
      should eq h
    end
    its(:height) { should be_nil }
  end

  context 'interdependent self-reference' do
    describe 'box a' do
      subject { @layout.box_a }
      its(:left)   { should eq 200 }
      its(:height) { should eq 125 }
    end

    describe 'box b' do
      subject { @layout.box_b }
      its(:top)    { should eq 700 }
      its(:height) { should eq 125 }
    end

    describe 'box c' do
      subject { @layout.box_c }
      its(:left)  { should eq 200 }
      its(:top)   { should eq 700 }
    end
  end

  describe 'math operations' do
    subject { @layout.math }
    its(:left)  { should eq 10 }
    its(:top)   { should eq 580 }
    its(:width)   { should eq 185 }
    its(:height)   { should eq 520.0 / 3 }
  end

  it 'inspects itself' do
    inspect_string = 'top: 700.0; left: 200.0; width: 500.0; height: 200.0; ' \
                      'bottom: 500.0; right: 700.0;'
    expect(@layout.simple_box.inspect).to eq inspect_string
  end

  context 'when unusual bounds are given' do
    describe 'no width' do
      subject { @layout.no_width }
      its(:width)  { should eq 100 }
    end

    describe 'no left' do
      subject { @layout.no_left }
      its(:left)  { should eq 1000 }
    end

    describe 'no top' do
      subject { @layout.no_top }
      its(:top)  { should eq 55 }
    end

    describe 'top and height' do
      subject { @layout.top_and_height }
      its(:top)  { should eq 70 }
      its(:height)  { should eq 55 }
      its(:bottom)  { should eq 15 }
    end

    describe 'when horizontally overdetermined' do
      subject { @layout.horizontally_overdetermined }
      it 'ignores the `right` specification' do
        expect(subject.right).to eq 330
      end
    end

    describe 'when vertically overdetermined' do
      subject { @layout.vertically_overdetermined }
      it 'ignores the `bottom` specification' do
        expect(subject.bottom).to eq 43
      end
    end

    describe 'when making a box with insufficient inputs' do
      subject { Bread::Basket::Poster::Box.new('.bread-box', @layout, @specs) }

      it 'fails if only 1 of left, right or width are given' do
        @specs = { 'left' => 15, 'top' => 33 }
        expect { subject }.to raise_error SystemExit
      end

      it 'fails if no top, but only bottom or height given' do
        @specs = { 'left' => 52, 'width' => 15, 'bottom' => 20 }
        expect { subject }.to raise_error SystemExit
      end
    end
  end
end
