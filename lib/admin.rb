require_relative 'room'
require_relative 'reservation'

module Hotel
  class Admin
    attr_reader :rooms, :reservations

    def initialize
      @rooms = load_rooms
      @reservations = load_reservations
    end

    def load_rooms
    end

    def load_reservations
    end

  end
end
