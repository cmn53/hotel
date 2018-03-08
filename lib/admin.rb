require_relative 'daterange'
require_relative 'room'
require_relative 'reservation'

module Hotel
  class Admin
    attr_reader :rooms, :reservations

    def initialize
      @rooms = load_rooms
      @reservations = []
    end

    def load_rooms
      rooms = []
      (1..20).each do |num|
        rooms << Room.new(num)
      end

      return rooms
    end

    def reserve_room(date_range)
      reservation_data = {
        id: next_reservation_id,
        date_range: date_range,
        room: find_available_rooms(date_range).sample # change later to find available rooms
      }

      new_reservation = Reservation.new(reservation_data)
      @reservations << new_reservation
      new_reservation.room.add_reservation(new_reservation)

      return new_reservation

    end

    def next_reservation_id
      if @reservations.empty?
        reservation_id =  1
      else
        reservation_id = @reservations.map { |res| res.id }.max + 1
      end

      return reservation_id
    end

    def find_reservations(date)
      reservations_by_date = @reservations.select do |reservation|
        reservation.date_range.include?(date)
      end

      return reservations_by_date
    end

    def find_available_rooms(date_range)
      available_rooms = @rooms.select do |room|
        room.is_available?(date_range)
      end

      return available_rooms
    end

  end
end
