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
      expect{subject.top_up(1)}.to raise_error("Maximum limit reached #{Oystercard::MAX_BALANCE}")
    end
  end
  describe '#deduct' do
    it 'decreases balance off card' do
      subject.top_up(5)
      subject.deduct(3)
      expect(subject.balance).to eq 2
    end
  end
  describe '#in_journey' do
    it 'returns false when not touched in' do
      expect(subject.in_journey?).to eq false
    end
  end
  describe '#touch_in' do
    it 'changes in_use to true when called' do
      subject.top_up(50)
      subject.touch_in
      expect(subject.in_journey?).to eq true
    end
    it 'raises an error if the balance is less than the minimum' do
      subject.top_up(Oystercard::MIN_BALANCE - 0.01)
      expect{ subject.touch_in }.to raise_error("Insufficient funds!")
    end
  end
  describe '#touch_out' do
    it 'changes in_use to false when called' do
      subject.top_up(50)
      subject.touch_in
      subject.touch_out
      expect(subject.in_journey?).to eq false
    end
  end
end
