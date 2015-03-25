describe Bread::Basket::Poster::Columns do
  # explanation of before all in css_reader_spec
  before(:all) do
    metadata = { 'stylesheet' => 'basic_flow'  }
    body = 'Nom nom nom'
    Bread::Basket::Poster.dir_path = './spec/poster/test_files'
    @layout = Bread::Basket::Poster::Layout.new(metadata, body)
  end

  it 'quits if specs are wrong' do
    specs = { 'left' => 2, 'top' => 40, 'width' => 100 }
    expect do
      Bread::Basket::Poster::Columns.new specs, @layout
    end.to raise_error SystemExit
  end

  it 'duplicates tops into an array of length count' do
    specs = { 'count' => 2, 'top' => 40 }
    columns = Bread::Basket::Poster::Columns.new specs, @layout
    expect(columns.tops).to eq [40, 40]
  end

  it 'uses top array as-is if count matches tops arr length' do
    specs = { 'count' => 2, 'top' => [37, 25] }
    columns = Bread::Basket::Poster::Columns.new specs, @layout
    expect(columns.tops).to eq [37, 25]
  end

  it 'makes symmetric tops for even column number' do
    specs = { 'count' => 4, 'top' => [40, 10] }
    columns = Bread::Basket::Poster::Columns.new specs, @layout
    expect(columns.tops).to eq [40, 10, 10, 40]
  end

  it 'makes symmetric tops for odd column number' do
    specs = { 'count' => 5, 'top' => [40, 10, 30] }
    columns = Bread::Basket::Poster::Columns.new specs, @layout
    expect(columns.tops).to eq [40, 10, 30, 10, 40]
  end

  it 'uses layout font to determine column spacing and widths' do
    specs = { 'count' => 5, 'top' => [40, 10, 30] }
    columns = Bread::Basket::Poster::Columns.new specs, @layout
    expect(columns.width).to eq 194.8
  end

  it 'fails to create symmetric tops for top input' do
    specs = { 'count' => 4, 'top' => [40, 10, 30] }
    expect do
      Bread::Basket::Poster::Columns.new specs, @layout
    end.to raise_error SystemExit
  end
end
