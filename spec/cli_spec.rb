# Some bare-bones CLI specs. At this point the CLI is so simple
# I'm not sure that it needs real specs . . .

describe Bread::Basket::Cli do
  context 'poster' do
    let(:file) { 'example.md' }

    it 'gives file to Poster' do
      expect(Bread::Basket::Poster::PosterMaker).to receive(:new).with(file)
      subject.poster(file)
    end
  end
end
