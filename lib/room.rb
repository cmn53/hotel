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

    def is_available?(date)
      if date.class != Date
        raise ArgumentError.new("Input must be an instance of Date class")
      end

      @reservations.each do |res|
        reservation_range = (res.start_date...res.end_date).to_a
        return false if reservation_range.include?(date)
      end
      return true
    end
  end
end
