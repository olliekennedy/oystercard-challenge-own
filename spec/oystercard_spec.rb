require 'oystercard'
RSpec.describe Oystercard do
  describe '#balance' do
    it 'checks the new card has a balance' do
      expect(subject.balance).to eq 0
    end
  end
  describe "#top_up" do
    it 'increases balance on card' do
      subject.top_up(5)
      expect(subject.balance).to eq 5
    end
    it 'raises an error if balance exceeds 90' do
      subject.top_up(90)
      expect{subject.top_up(1)}.to raise_error("Maximum limit reached #{Oystercard::MAXIMUM_CAPACITY}")
    end
  end
  describe '#deduct' do
    it 'decreases balance off card' do
      subject.top_up(5)
      subject.deduct(3)
      expect(subject.balance).to eq 2
    end
  end
end
