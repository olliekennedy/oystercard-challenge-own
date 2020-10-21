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
