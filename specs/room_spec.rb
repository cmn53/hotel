require_relative 'spec_helper'

describe 'Room class' do

  describe 'initialize method' do
    before do
      @room = Hotel::Room.new(1)
    end

    it 'creates an instance of Hotel' do
      @room.must_be_instance_of Hotel::Room
      @room.must_respond_to :number
      @room.must_respond_to :reservations
    end

    it 'has a number' do
      @room.number.must_be_kind_of Integer
    end

    it 'throws an error if the room number is not between 1 and 20' do
      proc { Hotel::Room.new(0) }.must_raise ArgumentError
      proc { Hotel::Room.new(21) }.must_raise ArgumentError
    end

    it 'creates an empty array of reservations' do
      @room.reservations.must_be_kind_of Array
      @room.reservations.length.must_equal 0
    end
  end

  describe 'add_reservation method' do
    before do
      @room = Hotel::Room.new(1)
      @date_range = Hotel::DateRange.new("Dec 31, 1999", "Jan 2, 2000").range
      reservation_data = {
        id: 100,
        date_range: @date_range,
        room: @room
      }
      @reservation = Hotel::Reservation.new(reservation_data)
    end

    it 'throws an error if input is not an instance of Reservation' do
      proc { @room.add_reservation(100) }.must_raise ArgumentError
    end

    it 'returns an array of reservations' do
      @room.add_reservation(@reservation).must_be_kind_of Array
      @room.reservations.length.must_equal 1
      @room.reservations.each do |reservation|
        reservation.must_be_instance_of Hotel::Reservation
      end
    end

  end

  describe 'is_available? method' do
    before do
      @room = Hotel::Room.new(1)
      @date_range = Hotel::DateRange.new("Dec 31, 1999", "Jan 2, 2000").range
      reservation_data = {
        id: 100,
        date_range: @date_range,
        room: @room
      }
      @reservation = Hotel::Reservation.new(reservation_data)
      @room.add_reservation(@reservation)
    end

    it 'returns true if the given date is before the reservation' do
      date = Date.parse("Dec 30, 1999")
      @room.is_available?(date).must_equal true
    end

    it 'returns true if the given date is after the reservation' do
      date = Date.parse("Jan 3, 2000")
      @room.is_available?(date).must_equal true
    end

    it 'returns true if the given date is the check-out date of the reservation' do
      date = Date.parse("Jan 2, 2000")
      @room.is_available?(date).must_equal true
    end

    it 'returns false if the given date overlaps the reservation date range' do
      date = Date.parse("Jan 1, 2000")
      @room.is_available?(date).must_equal false
    end

    it 'throws an error if the input is not a date' do
      proc { @room.is_available?(1) }.must_raise ArgumentError
    end
  end
end
