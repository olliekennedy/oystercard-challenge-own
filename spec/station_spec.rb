require './lib/station'

RSpec.describe Station do
  subject { described_class.new("KX", 1)}

  describe 'initialize' do
    it 'has a name' do
      expect(subject.name).to eq "KX"
    end
    it 'has a zone' do
      expect(subject.zone).to eq 1
    end
  end
end
