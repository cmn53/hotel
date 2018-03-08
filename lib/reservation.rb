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
      # exclusive range does not include end date,
      # count returns an Integer rather than the Rational returned by subtraction of two dates
      nights = date_range.count
      projected_cost = nights * COST_PER_NIGHT
#
      return projected_cost
    end
  end
end
