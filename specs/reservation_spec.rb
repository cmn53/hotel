require_relative 'spec_helper'

describe 'Reservation class' do
  describe 'initialize method' do
    before do
      @room = Hotel::Room.new(1)
      reservation_data = {
        id: 100,
        start_date: Date.parse("Dec 31, 1999"),
        end_date: Date.parse("Jan 2, 2000"),
        room: @room
      }
      @reservation = Hotel::Reservation.new(reservation_data)
    end

    it 'creates an instance of Reservation' do
      @reservation.must_be_instance_of Hotel::Reservation

      [:id, :start_date, :end_date, :room].each do |prop|
        @reservation.must_respond_to prop
      end

      @reservation.id.must_be_kind_of Integer
      @reservation.start_date.must_be_kind_of Date
      @reservation.end_date.must_be_kind_of Date
      @reservation.room.must_be_instance_of Hotel::Room
    end

    it 'throws an error if start date is later than end date' do
      room = Hotel::Room.new(1)
      reservation_data = {
        id: 100,
        start_date: Date.parse("Jan 2, 2000"),
        end_date: Date.parse("Dec 31, 1999"),
        room: room
      }

      proc { Hotel::Reservation.new(reservation_data) }.must_raise StandardError
    end

    it 'throws an error if start date is the same as end date' do
      @room = Hotel::Room.new(1)
      reservation_data = {
        id: 100,
        start_date: Date.parse("Jan 2, 2000"),
        end_date: Date.parse("Jan 2, 2000"),
        room: @room
      }

      proc { Hotel::Reservation.new(reservation_data) }.must_raise StandardError
    end
  end

  describe 'projected_cost method' do
    it 'calculates the projected cost of the reservation' do
      room = Hotel::Room.new(1)
      reservation_data = {
        id: 100,
        start_date: Date.parse("Dec 31, 1999"),
        end_date: Date.parse("Jan 2, 2000"),
        room: room
      }
      reservation = Hotel::Reservation.new(reservation_data)

      reservation.projected_cost.must_be_kind_of Integer
      reservation.projected_cost.must_equal 400
    end
  end
end
