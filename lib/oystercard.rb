class Oystercard

  attr_reader :balance
  MAXIMUM_CAPACITY = 90

  def initialize
    @balance = 0
  end

  def top_up(amount)
    raise("Maximum limit reached #{MAXIMUM_CAPACITY}") if @balance + amount > MAXIMUM_CAPACITY
    @balance += amount
  end

  def deduct(amount)
    @balance -= amount
  end
end
