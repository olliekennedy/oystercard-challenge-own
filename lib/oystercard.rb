class Oystercard
  attr_reader :balance, :entry_station, :journey_log

  MIN_FARE = 1
  MAX_BALANCE = 90
  PENALTY = 6

  def initialize
    @balance = 0
    @journey_log = []
    @journey = nil
  end

  def top_up(amount)
    raise("Maximum limit reached #{MAX_BALANCE}") if @balance + amount > MAX_BALANCE

    @balance += amount
  end

  def touch_in(station)
    deduct(PENALTY) if in_journey?
    # should we put this into fare?
    raise('Insufficient funds!') if @balance < MIN_FARE

    @journey = Journey.new(station)
  end

  def touch_out(station)
    deduct(fare)
    @journey.exit = station
    log_journey
    @journey = nil
  end

  private

  def in_journey?
    !!@journey
  end

  def log_journey
    @journey_log << @journey.log
  end

  def deduct(amount)
    @balance -= amount
  end

  def fare
    in_journey? ? MIN_FARE : PENALTY
  end
end
