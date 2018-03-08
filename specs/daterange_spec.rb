require_relative 'spec_helper'

describe 'DateRange class' do

  describe 'initialize method' do
    it 'can be created' do
      date_range = Hotel::DateRange.new('2018-03-09', '2018-03-12')
      date_range.must_be_instance_of Hotel::DateRange
      [:start_date, :end_date, :date_range].each do |prop|
        date_range.must_respond_to prop
      end
    end

    it 'throws an error if the date entry is an invalid format' do
      proc { Hotel::DateRange.new('','') }.must_raise StandardError
      # proc { Hotel::DateRange.new(4, 5) }.must_raise StandardError
      # proc { Hotel::DateRange.new('33, 4') }.must_raise StandardError
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
end
