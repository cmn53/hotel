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
        raise ArgumentError.new("Input must be an instance of Reservation")
      end

      @reservations << reservation
    end

    def is_available?(date_range)
      @reservations.each do |reservation|
        intersection = reservation.date_range & date_range
        return false unless intersection.empty?
      end
      return true
    end
  end
end
