describe Bread::Basket::PosterMaker do
  let(:good_file) { File.expand_path '../test_files/test_file.md', __FILE__ }
  let(:bad_file) { File.expand_path '../test_files/bad_file.md', __FILE__ }

  subject { Bread::Basket::PosterMaker.new(good_file) }

  it 'should read the front matter off the file' do
    expect(subject.metadata['key']).to eq 'value'
  end

  it 'should raise a NoMetaDataError if the file has no front matter' do
    error = Bread::Basket::NoMetadataError
    expect { Bread::Basket::PosterMaker.new(bad_file) }.to raise_error(error)
  end
end
