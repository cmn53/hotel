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
      @date_range = Hotel::DateRange.new('2018-03-09', '2018-03-16').range
    end

    it 'returns true if the room has no reservations' do
      @room.is_available?(@date_range).must_equal true
    end

    it 'returns true if the given date range doesnt overlap a reservation' do
      reservation_date_range = Hotel::DateRange.new('2018-04-09', '2018-04-16').range
      reservation_data = {
        id: 100,
        date_range: reservation_date_range,
        room: @room
      }
      reservation = Hotel::Reservation.new(reservation_data)
      @room.add_reservation(reservation)

      @room.is_available?(@date_range).must_equal true
    end

    it 'returns true if the given date range ends on the check-in date of a reservation' do
      reservation_date_range = Hotel::DateRange.new('2018-03-16', '2018-03-18').range
      reservation_data = {
        id: 100,
        date_range: reservation_date_range,
        room: @room
      }
      reservation = Hotel::Reservation.new(reservation_data)
      @room.add_reservation(reservation)

      @room.is_available?(@date_range).must_equal true
    end

    it 'returns true if the given date range begins on the check-out date of a reservation' do
      reservation_date_range = Hotel::DateRange.new('2018-03-07', '2018-03-09').range
      reservation_data = {
        id: 100,
        date_range: reservation_date_range,
        room: @room
      }
      reservation = Hotel::Reservation.new(reservation_data)
      @room.add_reservation(reservation)

      @room.is_available?(@date_range).must_equal true
    end

    it 'returns false if the given date range overlaps the beginning of a reservation' do
      reservation_date_range = Hotel::DateRange.new('2018-03-15', '2018-03-17').range
      reservation_data = {
        id: 100,
        date_range: reservation_date_range,
        room: @room
      }
      reservation = Hotel::Reservation.new(reservation_data)
      @room.add_reservation(reservation)

      @room.is_available?(@date_range).must_equal false
    end

    it 'returns false if the given date range overlaps the end of a reservation' do
      reservation_date_range = Hotel::DateRange.new('2018-03-07', '2018-03-10').range
      reservation_data = {
        id: 100,
        date_range: reservation_date_range,
        room: @room
      }
      reservation = Hotel::Reservation.new(reservation_data)
      @room.add_reservation(reservation)

      @room.is_available?(@date_range).must_equal false
    end

    it 'returns false if the given date range is completely contained by a reservation' do
      reservation_date_range = Hotel::DateRange.new('2018-03-07', '2018-03-18').range
      reservation_data = {
        id: 100,
        date_range: reservation_date_range,
        room: @room
      }
      reservation = Hotel::Reservation.new(reservation_data)
      @room.add_reservation(reservation)

      @room.is_available?(@date_range).must_equal false
    end

    it 'returns false if the given date range contains a reservation' do
      reservation_date_range = Hotel::DateRange.new('2018-03-11', '2018-03-13').range
      reservation_data = {
        id: 100,
        date_range: reservation_date_range,
        room: @room
      }
      reservation = Hotel::Reservation.new(reservation_data)
      @room.add_reservation(reservation)

      @room.is_available?(@date_range).must_equal false
    end
  end
end
