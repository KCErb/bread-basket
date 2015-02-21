describe Bread::Basket::Poster do
  let(:file_path) { 'spec/poster/test_files/' }
  let(:good_file) { File.expand_path file_path + 'good_file.md' }
  let(:no_front_matter) { File.expand_path file_path + 'no_front_matter.md' }
  let(:no_layout) { File.expand_path file_path + 'no_layout.md' }
  let(:bad_layout) { File.expand_path file_path + 'bad_layout.md' }
  let(:flow_layout) { File.expand_path file_path + 'flow_layout.md' }
  let(:block_layout) { File.expand_path file_path + 'block_layout.md' }

  context 'when a bad file is given' do
    it 'should fail if the file has no front matter' do
      error = Bread::Basket::Poster::NoFrontMatterError
      expect { subject.create(no_front_matter) }.to raise_error(error)
    end

    it 'should default to Flow if the file has no layout' do
      expect(Bread::Basket::Poster::FlowLayout).to receive(:new)
      subject.create(no_layout)
    end

    it 'should default to Flow if layout unrecognized' do
      expect(Bread::Basket::Poster::FlowLayout).to receive(:new)
      subject.create(bad_layout)
    end
  end

  context 'when a good file is given' do
    subject { Bread::Basket::Poster }
    it 'creates a flow layout if flow is given' do
      expect(Bread::Basket::Poster::FlowLayout).to receive(:new)
      subject.create(flow_layout)
    end

    it 'it does not create flow via default mechanism' do
      expect(Bread::Basket::Poster).not_to receive(:handle_else)
      subject.create(flow_layout)
    end

    it 'creates a block layout if block is given' do
      expect(Bread::Basket::Poster::BlockLayout).to receive(:new)
      subject.create(block_layout)
    end
  end
end
