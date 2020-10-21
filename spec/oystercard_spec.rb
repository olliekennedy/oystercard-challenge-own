require 'oystercard'
RSpec.describe Oystercard do
  let(:station) { double :station, :name => "KX" }
  let(:station2) { double :station2, :name => "Piccadilly Circus" }
  describe '#balance' do
    it 'checks the new card has a balance' do
      expect(subject.balance).to eq 0
    end
  end
  describe "#top_up" do
    it 'increases balance on card' do
      expect{ subject.top_up(5) }.to change{ subject.balance }.by(5)
    end
    it 'raises an error if balance exceeds 90' do
      subject.top_up(90)
      expect{ subject.top_up(1) }.to raise_error("Maximum limit reached #{Oystercard::MAX_BALANCE}")
    end
  end
  # describe '#deduct' do
  #   it 'decreases balance off card' do
  #     subject.top_up(5)
  #     subject.deduct(3)
  #     expect(subject.balance).to eq 2
  #   end
  # end
  describe '#in_journey' do
    it 'returns false when not touched in' do
      expect(subject.in_journey?).to eq false
    end
  end
  describe '#touch_in' do

    it 'changes in_use to true when called' do
      subject.top_up(50)
      subject.touch_in(station)
      expect(subject.in_journey?).to eq true
    end
    it 'raises an error if the balance is less than the minimum' do
      subject.top_up(Oystercard::MIN_FARE - 0.01)
      expect{ subject.touch_in(station) }.to raise_error("Insufficient funds!")
    end
    it 'saves the entry station info' do
    #  allow(station).to receive(:name).and_return("KX")
      subject.top_up(50)
      subject.touch_in(station)
      expect(subject.entry_station).to eq "KX"
    end
  end
  describe '#touch_out' do
    it 'changes in_use to false when called' do
      #pending("let's fix that thing first")
      subject.top_up(50)
      subject.touch_in(station)
      subject.touch_out(station)
      expect(subject.in_journey?).to eq false
    end
    it 'reduces the balance by the minimum fare' do
      subject.top_up(10)
      subject.touch_in(station)
      expect{ subject.touch_out(station) }.to change{ subject.balance }.by(-Oystercard::MIN_FARE)
    end

  end
  describe '.trip_log' do
    let(:journey){ {entry: station.name, exit: station2.name} }

    it 'stores a journey' do
      subject.touch_in(station)
      subject.touch_out(station2)
      expect(subject.trip_log).to include journey
    end
    before(:each) do
      subject.top_up(50)
    end
    it 'returns an empty journey list' do
      expect(subject.trip_log).to be_empty
    end
    context 'many trips' do
      before(:each) do
        subject.touch_in(station)
        subject.touch_out(station2)
      end
      it 'returns an array of one trip' do
        expect(subject.trip_log).to include journey
      end

      it 'returns an array of a return trip' do
        subject.touch_in(station2)
        subject.touch_out(station)
        expect(subject.trip_log).to eq [{ :entry=>"KX", :exit=>"Piccadilly Circus" },
                                        { :entry=>"Piccadilly Circus", :exit=>"KX" }]
      end
    end
  end
end
