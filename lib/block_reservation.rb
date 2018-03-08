module Hotel
  class BlockReservation

    attr_reader :id, :date_range, :room

    COST_PER_NIGHT = 150

    def initialize(input, block_id)
      super(input)
      @block_id = block_id
      @is_available = true
    end

  end
end
