describe Bread::Basket::Poster::PosterMaker do
  let(:file_path) { 'spec/poster/test_files/' }
  let(:good_file) { File.expand_path file_path + 'good_file.md' }
  let(:bad_file) { File.expand_path file_path + 'bad_file.md' }
  subject { Bread::Basket::Poster::PosterMaker }

  it 'creates a layout if front matter exists' do
    expect(Bread::Basket::Poster::Layout).to receive(:new)
    subject.new(good_file)
  end

  it 'should fail if the file has no front matter' do
    error = Bread::Basket::Poster::NoFrontMatterError
    expect { subject.new(bad_file) }.to raise_error(error)
  end
end
