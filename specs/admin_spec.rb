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

  end
end
