require_relative 'spec_helper'

describe 'Room class' do

  describe 'initialize method' do
    before do
      @room = Hotel::Room.new(1)
    end

    it 'creates an instance of Room' do
      @room.must_be_instance_of Hotel::Room
      @room.must_respond_to :number
    end

    it 'has a number' do
      @room.number.must_be_kind_of Integer
    end

    it 'throws an error if the room number is not between 1 and 20' do
      proc { Hotel::Room.new(0) }.must_raise ArgumentError
      proc { Hotel::Room.new(21) }.must_raise ArgumentError
    end
  end
end
