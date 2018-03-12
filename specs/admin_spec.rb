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

    it 'does not include reservations that end on the given date' do
      reservations = @hotel.find_reservations(Date.parse("May 8, 1982"))
      reservations.length.must_equal 1
      reservations.wont_include @reservation_3
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
      @reservation_1 = @hotel.reserve_room(date_range_1)
      @reservation_2 = @hotel.reserve_room(date_range_2)
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
      available_rooms.wont_include @reservation_1.room
      available_rooms.wont_include @reservation_2.room
    end

    it 'returns an empty array if there are no available rooms' do
      date_range = Hotel::DateRange.new("March 17, 2018", "March 18, 2018")
      20.times do
        @hotel.reserve_room(date_range)
      end

      @hotel.find_available_rooms(date_range).must_equal []
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
    end

    it 'accurately loads reservation data' do
      @reservation.id.must_be_kind_of Integer
      @reservation.id.must_equal 1
      @reservation.date_range.must_be_instance_of Hotel::DateRange
      @reservation.room.must_be_instance_of Hotel::Room
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

    it 'throws an error if all rooms have been blocked' do
      3.times do
        @hotel.create_block(5, @date_range)
      end
      @hotel.create_block(4, @date_range)
    
      proc { @hotel.reserve_room(@date_range) }.must_raise StandardError
    end
  end

  describe 'next_reservation_id helper method' do
    it 'assigns an id of 1 if there are no existing reservations' do
      hotel = Hotel::Admin.new
      hotel.next_reservation_id.must_equal 1
    end

    it 'assigns an id one higher than the highest existing reservation id' do
      hotel = Hotel::Admin.new
      range_1 = Hotel::DateRange.new("May 6, 1982", "May 10, 1982")
      range_2 = Hotel::DateRange.new("April 30, 1982", "May 1, 1982")
      hotel.reserve_room(range_1)
      hotel.reserve_room(range_2)

      hotel.next_reservation_id.must_equal 3
    end

    describe 'next_block_id helper method' do
      before do
        @hotel = Hotel::Admin.new
        @date_range = Hotel::DateRange.new("May 6, 1982", "May 10, 1982")
      end

      it 'assigns an id of 1 if there are no existing block reservations' do
        @hotel.next_block_id.must_equal 1
      end

      it 'assigns an id one higher than the highest existing block id' do
        reservation_data_1 = {
          id: 100,
          date_range: @date_range,
          room: 15,
          block_id: 1,
          block_status: :blocked
        }
        reservation_data_2 = {
          id: 200,
          date_range: @date_range,
          room: 16,
          block_id: 4,
          block_status: :blocked
        }
        reservation_1 = Hotel::Reservation.new(reservation_data_1)
        reservation_2 = Hotel::Reservation.new(reservation_data_2)
        @hotel.reservations.push(reservation_1, reservation_2)
        @hotel.next_block_id.must_equal 5
      end
    end

    describe 'create_block method' do
      before do
        @hotel = Hotel::Admin.new
        @date_range = Hotel::DateRange.new("May 6, 1982", "May 10, 1982")
      end

      it 'throws an error if the user tries to block more than 5 rooms' do
        proc { @hotel.create_block(6, @date_range) }.must_raise ArgumentError
      end

      it 'adds the block reservations to the hotels reservations' do
        @hotel.create_block(3, @date_range)
        @hotel.reservations.length.must_equal 3
      end

      it 'creates reservations with distinct reservation ids and rooms' do
        @hotel.create_block(3, @date_range)
        @hotel.reservations.map { |res| res.id }.uniq.length.must_equal 3
        @hotel.reservations.map { |res| res.room }.uniq.length.must_equal 3
      end

      it 'creates reservations with the same date ranges and block_ids' do
        @hotel.create_block(3, @date_range)
        @hotel.reservations.map { |res| res.date_range }.uniq.length.must_equal 1
        @hotel.reservations.map { |res| res.block_id }.uniq.length.must_equal 1
      end

      it 'throws an error if there are not enough rooms to create the block' do
        16.times do
          @hotel.reserve_room(@date_range)
        end

        proc { @hotel.create_block(5, @date_range) }.must_raise StandardError
      end
    end

    describe 'find_available_block_rooms method' do
      before do
        @hotel = Hotel::Admin.new
        @date_range = Hotel::DateRange.new("May 6, 1982", "May 10, 1982")
      end

      it 'returns an array of block reservations' do
        @hotel.create_block(3, @date_range)
        @hotel.find_available_block_rooms(1).must_be_kind_of Array
        @hotel.find_available_block_rooms(1).each do |reservation|
          reservation.must_be_instance_of Hotel::Reservation
          reservation.block_id.wont_be_nil
          reservation.block_status.wont_be_nil
        end
      end

      it 'finds the number of available rooms in a block given a block id' do
        @hotel.create_block(3, @date_range)
        @hotel.find_available_block_rooms(1).length.must_equal 3
        @hotel.reservations[0].change_status
        @hotel.find_available_block_rooms(1).length.must_equal 2
      end

      it 'returns an empty array if there are no available rooms in the block' do
        @hotel.create_block(1, @date_range)
        @hotel.reservations[0].change_status
        @hotel.find_available_block_rooms(1).must_equal []
      end
    end

    describe 'reserve_block_room method' do
      before do
        @hotel = Hotel::Admin.new
        @date_range = Hotel::DateRange.new("May 6, 1982", "May 10, 1982")
        @hotel.create_block(2, @date_range)
      end

      it 'throws an error if there are no availabe rooms in the requested block' do
        @hotel.reservations[0].change_status
        @hotel.reservations[1].change_status
        proc { @hotel.reserve_block_room(1) }.must_raise StandardError
      end

      it 'changes the block_status of the first available room from blocked to reserved' do
        @hotel.reservations[0].block_status.must_equal :blocked
        @hotel.reserve_block_room(1)
        @hotel.reservations[0].block_status.must_equal :reserved
      end

      it 'changes the number of available rooms in the block' do
        @hotel.find_available_block_rooms(1).length.must_equal 2
        @hotel.reserve_block_room(1)
        @hotel.find_available_block_rooms(1).length.must_equal 1
      end
    end
  end
end
