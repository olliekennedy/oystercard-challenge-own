class Oystercard

  attr_reader :balance
  MIN_BALANCE = 1
  MAX_BALANCE = 90

  def initialize
    @balance = 0
    @in_use = false
  end

  def top_up(amount)
    raise("Maximum limit reached #{MAX_BALANCE}") if @balance + amount > MAX_BALANCE

    @balance += amount
  end

  def deduct(amount)
    @balance -= amount
  end

  def in_journey?
    @in_use
  end

  def touch_in
    raise("Insufficient funds!") if @balance < MIN_BALANCE

    @in_use = true
  end

  def touch_out
    @in_use = false
  end
end
