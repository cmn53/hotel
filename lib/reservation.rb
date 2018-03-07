module Hotel
  class Reservation

    attr_reader :id, :start_date, :end_date, :room

    COST_PER_NIGHT = 200

    def initialize(input)
      @id = input[:id]
      @start_date = input[:start_date]
      @end_date = input[:end_date]
      @room = input[:room]

      if @end_date <= @start_date
        raise StandardError.new("End date of reservation must be at least one day later than starting date")
      end
    end

    def projected_cost
      # exclusive range does not include end date,
      # count returns an Integer rather than the Rational returned by subtraction of two dates
      nights = (@start_date...@end_date).count
      projected_cost = nights * COST_PER_NIGHT
# 
      return projected_cost
    end
  end
end
