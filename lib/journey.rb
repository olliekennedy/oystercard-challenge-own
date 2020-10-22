# frozen_string_literal: true

# This is the journey class
class Journey
  attr_accessor :entry_station, :exit

  def initialize(entry_station)
    @entry_station = entry_station
    @exit = nil
  end

  def log
    { entry: @entry_station.name, exit: @exit.name }
  end
end

# Thinking about creating a journey class - instantiate the journey as a hash
# then can add the entry and exit stations as functions from touch in/out
