# frozen_string_literal: true

require 'oystercard'
RSpec.describe Oystercard do
  let(:station) { double :station, name: :KX }
  let(:station2) { double :station2, name: :Piccadilly_Circus }
  describe '#balance' do
    it 'checks the new card has a balance' do
      expect(subject.balance).to eq 0
    end
  end
  describe '#top_up' do
    it 'increases balance on card' do
      expect { subject.top_up(5) }.to change { subject.balance }.by(5)
    end
    it 'raises an error if balance exceeds 90' do
      subject.top_up(90)
      expect { subject.top_up(1) }.to raise_error("Maximum limit reached #{Oystercard::MAX_BALANCE}")
    end
  end
  describe '#touch_in' do
    it 'raises an error if the balance is less than the minimum' do
      subject.top_up(Oystercard::MIN_FARE - 0.01)
      expect { subject.touch_in(station) }.to raise_error('Insufficient funds!')
    end
    context 'topup+touchin' do
      before(:each) do
        subject.top_up(50)
        subject.touch_in(station)
      end
      it 'saves the entry station info' do
        pending('check')
        # allow(station).to receive(:name).and_return("KX")
        expect(subject.entry_station).to eq :KX
      end
      it 'deducts penalty fare if 2x touch in' do
        expect { subject.touch_in(station) }.to change { subject.balance }.by(-Oystercard::PENALTY)
      end
    end
  end
  describe '#touch_out' do
    it 'reduces the balance by the minimum fare' do
      subject.top_up(10)
      subject.touch_in(station)
      expect { subject.touch_out(station) }.to change { subject.balance }.by(-Oystercard::MIN_FARE)
    end
  end
  describe '.journey_log' do
    let(:journey) { { entry: station.name, exit: station2.name } }
    before(:each) do
      subject.top_up(50)
    end
    it 'returns an empty journey list' do
      expect(subject.journey_log).to be_empty
    end
    context 'many journeys' do
      before(:each) do
        subject.touch_in(station)
        subject.touch_out(station2)
      end
      it 'returns an array of one journey' do
        expect(subject.journey_log).to include journey
      end
      it 'returns an array of a return journey' do
        subject.touch_in(station2)
        subject.touch_out(station)
        expect(subject.journey_log).to eq [{ entry: :KX, exit: :Piccadilly_Circus },
                                           { entry: :Piccadilly_Circus, exit: :KX }]
      end
    end
  end
end
