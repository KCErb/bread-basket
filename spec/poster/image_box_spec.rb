describe Bread::Basket::Poster::ImageBox do
  # explanation of before all in css_reader_spec
  # this is identical to the one used in Box since ImageBox
  # is a subclass of Box
  context 'with basic stylesheet' do
    before(:all) do
      metadata = { 'stylesheet' => 'self_referential'  }
      Bread::Basket::Poster.dir_path = './spec/poster/test_files'
      @name = '.simple-selector'
      @layout = Bread::Basket::Poster::Layout.new(metadata)
    end

    describe 'image has dimensions' do
      subject { @layout.drgn_image }
      its(:top)    { should eq(720) }
      its(:right) { should eq(1080) }
      its(:height) { should eq(412) }
      its(:width) { should eq(504) }
    end

    it "fails when the image can't be found" do
      expect do
        @specs = { 'src' => 'drgn.png', 'top' => 33, 'left' => 43 }
        Bread::Basket::Poster::ImageBox.new('.bread-box', @layout, @specs)
      end.to raise_error SystemExit
    end
  end

  context 'with fitted-image' do
    before(:all) do
      metadata = { 'stylesheet' => 'fitted_image'  }
      Bread::Basket::Poster.dir_path = './spec/poster/test_files'
      @name = '.simple-selector'
      @layout = Bread::Basket::Poster::Layout.new(metadata)
    end

    describe 'fixed width matches width, fits height' do
      subject { @layout.drgn_image1 }
      its(:width)   { should eq(400) }
      its(:height)  { should be_within(0.02).of(327) }
    end

    describe 'fixed height matches height, fits width' do
      subject { @layout.drgn_image2 }
      its(:height)   { should eq(400) }
      its(:width)  { should be_within(0.025).of(489.3) }
    end

    describe 'fixed width and height where height < width, matches height and fits width' do
      subject { @layout.drgn_image3 }
      its(:width)   { should eq(300) }
      its(:height)  { should be_within(0.01).of(245.23) }
    end

    describe 'fixed width and height where width < height, matches height and fits width' do
      subject { @layout.drgn_image4 }
      its(:height)  { should eq(300) }
      its(:width)   { should be_within(0.01).of(367) }
    end

    it 'inspects itself' do
      # I suspect this isn't ideal, I just copied and pasted the output to get this string
      inspect_string = 'top: 1000.0; left: 600.0; width: 400.0; height: 326.984126984127;' \
                       ' bottom: 673.015873015873; right: 1000.0; box_width: 400.0;' \
                       ' box_height: 412; im_width: 400.0; im_height: 326.984126984127;'
      expect(@layout.drgn_image1.inspect).to eq inspect_string
    end
  end
end
