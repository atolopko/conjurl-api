class DatabaseSequenceGenerator
  def next
    ActiveRecord::Base.connection.
      execute("SELECT nextval('short_url_key_seq')").
      first['nextval']
  end
end
