require_relative 'spec_helper'

describe 'Admin class' do
  describe 'initialize method' do
    before do
      @hotel = Hotel::Admin.new
    end

    it 'can be created' do
      @hotel.must_be_instance_of Hotel::Admin
      @hotel.must_respond_to :rooms
      @hotel.must_respond_to :reservations
    end

    it 'includes an array of rooms' do
      @hotel.rooms.must_be_kind_of Array
      @hotel.rooms.length.must_equal 20
      @hotel.rooms.each do |room|
        room.must_be_instance_of Hotel::Room
      end
    end

    it 'includes an empty array of reservations' do
      @hotel.reservations.must_be_kind_of Array
      @hotel.reservations.must_be_empty
    end
  end

  describe 'reserve_room method' do
    before do
      @hotel = Hotel::Admin.new
      @date_range = Hotel::DateRange.new("Dec 31, 1999", "Jan 2, 2000")
      @reservation = @hotel.reserve_room(@date_range)
    end

    it 'creates a new reservation' do
      @reservation.must_be_instance_of Hotel::Reservation

      [:id, :date_range, :room].each do |prop|
        @reservation.must_respond_to prop
      end
    end

    it 'accurately loads reservation data' do
      @reservation.id.must_be_kind_of Integer
      @reservation.id.must_equal 1
      @reservation.date_range.must_be_kind_of Hotel::DateRange
      @reservation.date_range.range.each do |date|
        date.must_be_kind_of Date
      end
      @reservation.room.must_be_instance_of Hotel::Room
    end

    it 'assigns a room to the reservation' do
      assigned_room = @reservation.room
      assigned_room.must_be_instance_of Hotel::Room
    end

    it 'adds the reservation to the hotels list of reservations' do
      @hotel.reservations.must_include @reservation
    end

    it 'throws an error if there are no available rooms' do
      19.times do
        @hotel.reserve_room(@date_range)
      end

      proc { @hotel.reserve_room(@date_range) }.must_raise StandardError
    end
  end

  describe 'next_reservation_id helper method' do
    it 'assigns an id of 1 if there are no existing reservations' do
      hotel = Hotel::Admin.new
      hotel.next_reservation_id.must_equal 1
    end

    it 'creates a unique reservation id' do
      hotel = Hotel::Admin.new
      range_1 = Hotel::DateRange.new("May 6, 1982", "May 10, 1982")
      range_2 = Hotel::DateRange.new("April 30, 1982", "May 1, 1982")
      range_3 = Hotel::DateRange.new("May 5, 1982", "May 8, 1982")
      hotel.reserve_room(range_1)
      hotel.reserve_room(range_2)
      hotel.reserve_room(range_3)

      res_ids = hotel.reservations.map { |reservation| reservation.id }
      res_ids.uniq.length.must_equal 3
    end
  end

  describe 'find_reservations method' do
    before do
      @hotel = Hotel::Admin.new
      range_1 = Hotel::DateRange.new("May 6, 1982", "May 10, 1982")
      range_2 = Hotel::DateRange.new("April 30, 1982", "May 1, 1982")
      range_3 = Hotel::DateRange.new("May 5, 1982", "May 8, 1982")
      @reservation_1 = @hotel.reserve_room(range_1)
      @reservation_2 = @hotel.reserve_room(range_2)
      @reservation_3 = @hotel.reserve_room(range_3)
    end

    it 'returns an array of reservations' do
      reservations = @hotel.find_reservations(Date.parse("May 6, 1982"))
      reservations.must_be_kind_of Array
      reservations.each do |reservation|
        reservation.must_be_instance_of Hotel::Reservation
      end
    end

    it 'accurately accounts for the number of reservations that overlap the given date' do
      reservations = @hotel.find_reservations(Date.parse("May 6, 1982"))
      reservations.length.must_equal 2
      reservations.must_include @reservation_1
      reservations.must_include @reservation_3
      reservations.wont_include @reservation_2
    end

    it 'returns an empty array if the date does not overlap any reservations' do
      @hotel.find_reservations(Date.parse("May 2, 1982")).must_equal []
    end
  end

  describe 'find_available_rooms method' do
    before do
      @hotel = Hotel::Admin.new
      date_range_1 = Hotel::DateRange.new("May 6, 1982", "May 10, 1982")
      date_range_2 = Hotel::DateRange.new("May 5, 1982", "May 8, 1982")
      @date_range_3 = Hotel::DateRange.new("May 6, 1982", "May 8, 1982")
      @hotel.reserve_room(date_range_1)
      @hotel.reserve_room(date_range_2)
    end

    it 'returns an array of rooms' do
      available_rooms = @hotel.find_available_rooms(@date_range_3)
      available_rooms.must_be_kind_of Array
      available_rooms.each do |room|
        room.must_be_instance_of Hotel::Room
      end
    end

    it 'accurately accounts for the number of available rooms' do
      available_rooms = @hotel.find_available_rooms(@date_range_3)
      available_rooms.length.must_equal 18
    end

    it 'returns an empty array if there are no available rooms' do
      date_range = Hotel::DateRange.new("March 17, 2018", "March 18, 2018")
      20.times do
        @hotel.reserve_room(date_range)
      end

      @hotel.find_available_rooms(date_range).must_be_empty
    end
  end

end
