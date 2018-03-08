require 'date'

module Hotel
  class DateRange

    attr_reader :start_date, :end_date, :date_range

    def initialize(start_date, end_date)
      @start_date = Date.parse(start_date)
      @end_date = Date.parse(end_date)
      @range = range

      [@start_date, @end_date].each do |date|
        if date.class != Date
          raise StandardError.new("Invalid date format. Accepted formats include 'YYYY-MM-DD' or 'YYYY/MM/DD'.")
        end
      end

      if @end_date <= @start_date
        raise StandardError.new("End date must be at least one day later than starting date.")
      end
    end

    def range
      return (@start_date...@end_date).to_a
    end

  end
end
