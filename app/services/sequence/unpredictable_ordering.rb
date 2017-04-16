module Sequence
  class UnpredictableOrdering
    def initialize(base_sequence:,
                   step:,
                   max_value:)
      @base_sequence = base_sequence
      @step = step
      @max_value = max_value
    end
    
    def next
      n = @base_sequence.next
      return nil if n.nil?
      (n * @step) % @max_value
    end
  end
end
