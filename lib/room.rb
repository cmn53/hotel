module Hotel
  class Room

    attr_reader :number, :reservations

    def initialize(num)

      if num < 1 || num > 20
        raise ArgumentError.new("Room number must be between 1 and 20")
      end

      @number = num
    end

    # def add_reservation(reservation)
    #   if reservation.class != Reservation
    #     raise ArgumentError.new("Input must be an instance of Reservation")
    #   end
    #
    #   @reservations << reservation
    # end
    #
    # def is_available?(date_range)
    #   @reservations.each do |reservation|
    #     return false if reservation.overlap?(date_range)
    #   end
    #
    #   return true
    # end
  end
end
