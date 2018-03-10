require_relative 'spec_helper'

describe 'Reservation class' do
  describe 'initialize method' do
    before do
      @room = Hotel::Room.new(1)
      @date_range = Hotel::DateRange.new('2018-03-09', '2018-03-12')
      reservation_data = {
        id: 100,
        date_range: @date_range,
        room: @room,
        block_id: 1,
        block_status: :blocked
      }
      @reservation = Hotel::Reservation.new(reservation_data)
    end

    it 'creates an instance of Reservation' do
      @reservation.must_be_instance_of Hotel::Reservation

      [:id, :date_range, :room, :block_id, :block_status].each do |prop|
        @reservation.must_respond_to prop
      end

      @reservation.id.must_be_kind_of Integer
      @reservation.date_range.must_be_instance_of Hotel::DateRange
      @reservation.room.must_be_instance_of Hotel::Room
      @reservation.block_id.must_be_kind_of Integer
      @reservation.block_status.must_be_kind_of Symbol
    end
  end

  describe 'cost method' do
    it 'calculates the projected cost of the reservation' do
      room = Hotel::Room.new(1)
      date_range = Hotel::DateRange.new('2018-03-09', '2018-03-12')
      reservation_data = {
        id: 100,
        date_range: date_range,
        room: room
      }
      reservation = Hotel::Reservation.new(reservation_data)

      reservation.cost.must_be_kind_of Float
      reservation.cost.must_equal 600.0
    end

    it 'calculates the projected cost of the reservation if it is part of a block' do
      room = Hotel::Room.new(1)
      date_range = Hotel::DateRange.new('2018-03-09', '2018-03-12')
      reservation_data = {
        id: 100,
        date_range: date_range,
        room: room,
        block_id: 1
      }
      reservation = Hotel::Reservation.new(reservation_data)

      reservation.cost.must_be_kind_of Float
      reservation.cost.must_equal 450.0
    end
  end

  # Reservation#overlap? method not tested because it only calls the DateRange#overlap method
  # Tests for DateRange#overlap? included in date_range_spec file
end
