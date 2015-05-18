describe Bread::Basket::Poster::PDFBuilder do
  context 'when metadata contains boxes' do
    # explanation of before(:each) in css_reader_spec
    before(:each) do
      metadata = { 'stylesheet' => 'builder',
                   'A' => 'Box content!',
                   'S1' => 'Stretchy content!',
                   'B' => 'Box content!',
                   'S2' => 'Stretchy content!'
                 }
      Bread::Basket::Poster.dir_path = './spec/poster/test_files'
      Bread::Basket::Poster.layout = Bread::Basket::Poster::Layout.new(metadata)
    end

    subject { Bread::Basket::Poster::PDFBuilder.new }

    it 'creates a PDF' do
      expect(subject.pdf).to be_a Prawn::Document
    end

    it 'creates a text_renderer' do
      expect(subject.text_renderer).to be_a Redcarpet::Markdown
    end

    # this stylesheet has lots of dependence on stretchy boxes to check for builder's
    # ability to resolve them *after* stretchy size has been determined
    # BEFORE
    it 'starts out with most boxes pending' do
      expect(subject.layout.pending).to eq %w(columns[0] .A .S2 .B)
    end

    # AFTER
    it 'builds the boxes and leaves none pending' do
      subject.boxes_from_metadata
      expect(subject.layout.pending).to eq []
    end
  end

  context 'when given a circular stylesheet' do
    before(:all) do
      metadata = { 'stylesheet' => 'circular',
                   'A' => 'Box content!',
                   'S1' => 'Stretchy content!',
                   'B' => 'Box content!',
                   'S2' => 'Stretchy content!'
                 }
      Bread::Basket::Poster.dir_path = './spec/poster/test_files'
      Bread::Basket::Poster.layout = Bread::Basket::Poster::Layout.new(metadata)
    end

    it 'should fail to resolve any boxes' do
      subject.boxes_from_metadata
      expect(subject.layout.pending).to eq %w(columns[0] .S1 .A .S2 .B)
    end
  end

  context 'when boxes are in body only' do
    # BLOCKS
  end
end
