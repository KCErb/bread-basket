class Test
  include Bread::Basket::Poster::UnitsHelper
end
describe Bread::Basket::Poster::UnitsHelper do
  describe '#convert_units' do
    subject { Test.new }

    it 'converts a valid measurement string' do
      value = '1.in'
      expect(subject.convert_units(value)).to eq 72
    end

    it "doesn't evil invalid measurement strings" do
      value = '`mkdir evil`'
      expect(subject.convert_units(value)).to eq value
    end

    it 'turns numbers into floats' do
      value = '5'
      expect(subject.convert_units(value)).to eq 5.0
    end

    it 'strips strings down' do
      value = ' space '
      expect(subject.convert_units(value)).to eq 'space'
    end
  end

  describe '#convert_inner_units' do
    subject { Test.new }
    it 'picks out pieces of an expression that it can fix' do
      value = ' 2 * margin + 1.ft '
      expect(subject.convert_inner_units(value)).to eq '2 * margin + 864'
    end
  end
end
