# require 'date'
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

    def reserve_room(start_date, end_date) # Dates must be entered as strings
      reservation_data = {
        id: next_reservation_id,
        start_date: Date.parse(start_date),
        end_date: Date.parse(end_date),
        room: @rooms.sample # change later to find available rooms
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
      reservations_by_date = []

      @reservations.each do |res|
        reservation_dates = (res.start_date...res.end_date).to_a
        if reservation_dates.include?(date)
          reservations_by_date << res
        end
      end

      return reservations_by_date
    end


    # def find_available_rooms(start_date, end_date)
    #   available_rooms = []
    #
    #   reservation_range = (Date.parse(start_date)..Date.parse(end_date)-1).to_a
    #
    #   @rooms.each do |room|
    #
    #     conflicts = false
    #
    #     room.reservations.each do |reservation|
    #       booked_range = (start_date..end_date - 1).to_a
    #       intersection = reservation_range & booked_range
    #       unless intersection.empty?
    #         conflicts = true
    #         break
    #       end
    #     end
    #
    #     if conflicts == false
    #       available_rooms << room
    #     end
    #   end
    #
    #   return available_rooms
    # end

  end
end
