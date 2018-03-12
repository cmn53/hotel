module Hotel
  class Room

    attr_reader :number

    def initialize(num)

      if num < 1 || num > 20
        raise ArgumentError.new("Room number must be between 1 and 20")
      end

      @number = num
    end
  end
end
