describe Bread::Basket::Poster::ImageBox do
  # explanation of before all in css_reader_spec
  # this is identical to the one used in Box since ImageBox
  # is a subclass of Box
  before(:all) do
    metadata = { 'stylesheet' => 'self_referential'  }
    body = 'Nom nom nom'
    Bread::Basket::Poster.dir_path = './spec/poster/test_files'
    @name = '.simple-selector'
    @layout = Bread::Basket::Poster::Layout.new(metadata, body)
  end

  describe 'image has dimensions' do
    subject { @layout.columns[0] }
    its(:top)    { should eq(500) }
    its(:height) { should eq(495) }
  end

  it "fails when the image can't be found" do
    expect do
      @specs = { 'src' => 'drgn.png', 'top' => 33, 'left' => 43 }
      Bread::Basket::Poster::ImageBox.new('.bread-box', @layout, @specs)
    end.to raise_error SystemExit
  end
end
