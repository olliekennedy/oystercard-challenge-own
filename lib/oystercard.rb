class Oystercard

  attr_reader :balance, :entry_station
  MIN_FARE = 1
  MAX_BALANCE = 90

  def initialize
    @balance = 0
    @entry_station = nil
  end

  def top_up(amount)
    raise("Maximum limit reached #{MAX_BALANCE}") if @balance + amount > MAX_BALANCE
    @balance += amount
  end

  def in_journey?
    !!@entry_station
  end

  def touch_in(station)
    raise("Insufficient funds!") if @balance < MIN_FARE
    @entry_station = station.name
  end

  def touch_out
    @balance -= MIN_FARE
    @entry_station = nil
  end

  private
  def deduct(amount)
    @balance -= amount
  end
end
