require_relative 'spec_helper'

describe 'DateRange class' do

  describe 'initialize method' do
    it 'can be created' do
      date_range = Hotel::DateRange.new('2018-03-09', '2018-03-12')
      date_range.must_be_instance_of Hotel::DateRange
      [:start_date, :end_date].each do |prop|
        date_range.must_respond_to prop
      end
    end

    it 'throws an error if the date entry is an invalid format' do
      proc { Hotel::DateRange.new('','') }.must_raise StandardError
      proc { Hotel::DateRange.new(4, 5) }.must_raise StandardError
      proc { Hotel::DateRange.new('33', '4') }.must_raise StandardError
    end

    it 'throws an error if the starting and ending dates are the same' do
      proc { Hotel::DateRange.new('2018-03-09', '2018-03-09') }.must_raise StandardError
    end

    it 'throws an error if the ending date is earlier than the starting date' do
      proc { Hotel::DateRange.new('2018-03-09', '2018-03-08') }.must_raise StandardError
    end
  end

  describe 'range method' do
    before do
      @date_range = Hotel::DateRange.new('2018-03-09', '2018-03-12')
    end

    it 'returns an array of dates' do
      @date_range.range.must_be_kind_of Array
      @date_range.range.each do |date|
        date.must_be_kind_of Date
      end
    end

    it 'includes the starting date and intermediate dates' do
      @date_range.range.must_include @date_range.start_date
      @date_range.range.must_include @date_range.start_date + 1
      @date_range.range.must_include @date_range.start_date + 2
    end

    it 'does not include the ending date' do
      @date_range.range.wont_include @date_range.end_date
    end
  end

  describe 'overlap? method' do
    before do
      @room = Hotel::Room.new(1)
      @date_range = Hotel::DateRange.new('2018-03-09', '2018-03-16')
    end

    it 'returns false if there is no overlap between the date ranges' do
      other = Hotel::DateRange.new('2018-04-09', '2018-04-16')
      @date_range.overlap?(other).must_equal false
    end

    it 'returns false if the given date range ends on the start date of the date range instance' do
      other = Hotel::DateRange.new('2018-03-16', '2018-03-18')
      @date_range.overlap?(other).must_equal false
    end

    it 'returns false if the given date range begins on the end date of the date range instance' do
      other = Hotel::DateRange.new('2018-03-07', '2018-03-09')
      @date_range.overlap?(other).must_equal false
    end

    it 'returns true if the given date range overlaps the beginning of the date range instance' do
      other = Hotel::DateRange.new('2018-03-15', '2018-03-17')
      @date_range.overlap?(other).must_equal true
    end

    it 'returns true if the given date range overlaps the end of the date range instance' do
      other = Hotel::DateRange.new('2018-03-07', '2018-03-10')
      @date_range.overlap?(other).must_equal true
    end

    it 'returns true if the given date range is completely contained by the date range instance' do
      other = Hotel::DateRange.new('2018-03-07', '2018-03-18')
      @date_range.overlap?(other).must_equal true
    end

    it 'returns true if the given date range contains the date range instance' do
      other = Hotel::DateRange.new('2018-03-11', '2018-03-13')
      @date_range.overlap?(other).must_equal true
    end
  end
end
