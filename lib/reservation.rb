module Hotel
  class Reservation

    attr_reader :id, :start_date, :end_date, :room

    def initialize(input)
      @id = input[:id]
      @start_date = input[:start_date]
      @end_date = input[:end_date]
      @room = input[:room]
    end

  end
end
