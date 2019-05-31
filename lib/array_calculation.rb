class ArrayCalculation
  class << self
    def average(arr)
      arr.inject{ |sum, el| sum + el }.to_f / arr.size
    end

    def new_average(new_val, old_average, old_count)
      new_count = old_count + 1
      ((old_average * (new_count - 1)) + new_val) / new_count
    end
  end
end
