class AddShortUrlKeySequence < ActiveRecord::Migration[5.0]
  def up
    execute <<-SQL
      CREATE SEQUENCE short_url_key_seq;
    SQL
  end

  def down
    execute <<-SQL
      DROP SEQUENCE short_url_key_seq;
    SQL
  end
end
