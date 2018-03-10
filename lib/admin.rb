require_relative 'date_range'
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

    def find_reservations(date)
      reservations_by_date = @reservations.select do |res|
        res.date_range.range.include?(date)
      end

      return reservations_by_date
    end

    def find_available_rooms(date_range)
      available_rooms = []

      conflicts = @reservations.select do |reservation|
        reservation.overlap?(date_range)
      end

      unavailable_rooms = conflicts.map { |res| res.room }

      available_rooms = @rooms - unavailable_rooms
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

      return new_reservation
    end

    def next_reservation_id
      return 1 if @reservations.empty?
      return @reservations.map { |res| res.id }.max + 1
    end

    def create_block(num_rooms, date_range, block_id)
      if find_available_rooms(date_range).empty?
        raise StandardError.new("There are no available rooms for that date range.")
      end

      num_rooms.times do
        reservation_data = {
          id: next_reservation_id,
          date_range: date_range,
          room: find_available_rooms(date_range).sample,
          block_id: block_id
        }
        new_block_reservation = Reservation.new(reservation_data)
        @reservations << new_block_reservation
        #new_block_reservation.room.add_reservation(new_block_reservation)
      end
    end

    def find_available_block_rooms(block_id)
      available_block_rooms = @reservations.select do |res|
        res.block_id == block_id && res.block_status == :blocked
      end
    end
  end
end
