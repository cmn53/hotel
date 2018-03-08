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
      @reservation = @hotel.reserve_room("Dec 31, 1999", "Jan 2, 2000")
    end

    it 'creates a new reservation' do
      @reservation.must_be_instance_of Hotel::Reservation

      [:id, :start_date, :end_date, :room].each do |prop|
        @reservation.must_respond_to prop
      end
    end

    it 'accurately loads reservation data' do
      @reservation.id.must_be_kind_of Integer
      @reservation.id.must_equal 1
      @reservation.start_date.must_be_kind_of Date
      @reservation.start_date.must_equal Date.new(1999,12,31)
      @reservation.end_date.must_be_kind_of Date
      @reservation.end_date.must_equal Date.new(2000,1,2)
      @reservation.room.must_be_instance_of Hotel::Room
    end

    it 'associates the reservation with a room' do
      assigned_room = @reservation.room
      assigned_room.must_be_instance_of Hotel::Room
      assigned_room.reservations.must_include @reservation
    end

    it 'adds the reservation to the hotels list of reservations' do
      @hotel.reservations.must_include @reservation
    end
  end

  describe 'next_reservation_id helper method' do
    it 'assigns an id of 1 if there are no existing reservations' do
      hotel = Hotel::Admin.new
      hotel.next_reservation_id.must_equal 1
    end

    it 'creates a unique reservation id' do
      hotel = Hotel::Admin.new
      hotel.reserve_room("May 6, 1982", "May 10, 1982")
      hotel.reserve_room("April 30, 1982", "May 1, 1982")
      hotel.reserve_room("May 4, 1982", "May 5, 1982")

      res_ids = hotel.reservations.map { |reservation| reservation.id }
      res_ids.uniq.length.must_equal 3
    end
  end

  describe 'find_reservations method' do
    before do
      @hotel = Hotel::Admin.new
      @reservation_1 = @hotel.reserve_room("May 6, 1982", "May 10, 1982")
      @reservation_2 = @hotel.reserve_room("April 30, 1982", "May 1, 1982")
      @reservation_3 = @hotel.reserve_room("May 5, 1982", "May 8, 1982")
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
end
