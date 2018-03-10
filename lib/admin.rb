require_relative 'date_range'
require_relative 'room'
require_relative 'reservation'

module Hotel
  class Admin
    attr_reader :rooms, :reservations

    def initialize
      @rooms = load_rooms
      @reservations = []
      @block_reservations = []
    end

    def load_rooms
      rooms = []
      (1..20).each do |num|
        rooms << Room.new(num)
      end

      return rooms
    end

    def reserve_room(date_range)
      if find_available_rooms(date_range).empty?
        raise StandardError.new("There are no available rooms for that date range.")
      end

      reservation_data = {
        id: next_reservation_id,
        date_range: date_range,
        room: find_available_rooms(date_range).sample
      }

      new_reservation = Reservation.new(reservation_data)
      @reservations << new_reservation
      new_reservation.room.add_reservation(new_reservation)

      return new_reservation

    end

    def create_block(num_rooms, date_range)
      if find_available_rooms(date_range).empty?
        raise StandardError.new("There are no available rooms for that date range.")
      end

      num_rooms.times do
        reservation_data = {
          id: next_reservation_id,
          date_range: date_range,
          room: find_available_rooms(date_range).sample
        }
        block_id = 1 #TODO: fix later
        new_block_reservation = BlockReservation.new(reservation_data, block_id)
        @block_reservations << new_block_reservation
        new_block_reservation.room.add_reservation(new_block_reservation)
      end
    end

    def find_available_block_rooms(block_id)
      block_rooms = @block_reservations.select do |room|
        block_reservations.id == block_id && block
      end

      block_rooms.select


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
        reservation.date_range.range.include?(date)
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
