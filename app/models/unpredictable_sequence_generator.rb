class UnpredictableSequenceGenerator
  def initialize(base_generator:,
                 key_namespace_size:,
                 step:)
    @base_generator = base_generator
    @key_namespace_size = key_namespace_size
    @step = step
  end
  
  def next
    n = @base_generator.next
    (n * @step) % @key_namespace_size
  end
end
