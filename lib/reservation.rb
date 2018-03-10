module Hotel
  class Reservation

    attr_reader :id, :date_range, :room, :block_id, :block_status

    COST_PER_NIGHT = 200.0
    BLOCK_DISCOUNT = 0.25

    def initialize(input)
      @id = input[:id]
      @date_range = input[:date_range]
      @room = input[:room]
      @block_id = input[:block_id]
      @block_status = input[:block_status]
    end

    def cost
      nights = @date_range.range.count
      cost = nights * COST_PER_NIGHT
      cost *= (1 - BLOCK_DISCOUNT) if @block_id != nil

      return cost
    end

    def overlap?(date_range)
      return @date_range.overlap?(date_range)
    end

    def change_status
      if @block_status == :blocked
        @block_status = :reserved
      else
       @block_status = :blocked
      end

      return @block_status
    end
  end
end
