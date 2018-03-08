require_relative 'spec_helper'

describe 'Admin class' do

  before do
    @hotel = Hotel::Admin.new
  end

  it 'can be created' do
    @hotel.must_be_instance_of Hotel::Admin
    @hotel.must_respond_to :rooms
    @hotel.must_respond_to :reservations

    @hotel.rooms.must_be_kind_of Array
    @hotel.rooms.length.must_equal 20
    @hotel.rooms.each do |room|
      room.must_be_instance_of Hotel::Room
    end

    @hotel.reservations.must_be_kind_of Array
    @hotel.reservations.must_be_empty
  end


end
