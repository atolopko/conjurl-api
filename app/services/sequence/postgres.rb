module Sequence
  class Postgres
    def initialize(sequence_name:,
                   max_value:)
      @sequence_name = sequence_name
      @max_value = max_value
    end
    
    def next
      n = ActiveRecord::Base.connection.
            execute("SELECT nextval('#{@sequence_name}')").
            first['nextval']
      n > @max_value ? nil : n
    end
  end
end
