module Hotel
  class Room

    COST_PER_NIGHT = 200

    attr_reader :number, :reservations

    def initialize(num)

      if num < 1 || num > 20
        raise ArgumentError.new("Room number must be between 1 and 20")
      end

      @number = num
      @reservations = []
    end

    def add_reservation(reservation)
      if reservation.class != Reservation
        raise ArgumentError.new("Input is not an instance of Reservation")
      end

      @reservations << reservation
    end
  end
end
