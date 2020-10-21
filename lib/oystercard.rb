class Oystercard

  attr_reader :balance, :entry_station, :trip_log
  MIN_FARE = 1
  MAX_BALANCE = 90

  def initialize
    @balance = 0
    @entry_station = nil
    @trip_log = []
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

  def touch_out(station)
    @balance -= MIN_FARE
    log_trip(station)
    @entry_station = nil
  end

  # Thinking about creating a trip class - instantiate the trip as a hash
  # then can add the entry and exit stations as functions from touch in/out

  private
  def log_trip(station)
    @trip_log << { entry: @entry_station, exit: station.name }
  end

  def deduct(amount)
    @balance -= amount
  end
end
