module Hotel
  class Reservation

    attr_reader :id, :date_range, :room

    COST_PER_NIGHT = 200

    def initialize(input)
      @id = input[:id]
      @date_range = input[:date_range]
      @room = input[:room]
    end

    def projected_cost
      nights = date_range.count
      projected_cost = nights * COST_PER_NIGHT

      return projected_cost
    end

    def overlap?(date_range)
      return @date_range.overlap?(date_range)
    end
  end
end
