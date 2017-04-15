class DatabaseSequenceGenerator
  def initialize(key_namespace_size:)
    @key_namespace_size = key_namespace_size
  end
  
  def next
    n = ActiveRecord::Base.connection.
          execute("SELECT nextval('short_url_key_seq')").
          first['nextval']
    raise "key namespace exhausted: #{n} > #{@key_namespace_size}" if n > @key_namespace_size
    n
  end
end
