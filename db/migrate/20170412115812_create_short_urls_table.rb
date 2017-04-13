class CreateShortUrlsTable < ActiveRecord::Migration[5.0]
  def up
    execute <<-SQL
      CREATE TABLE short_urls (
        id SERIAL PRIMARY KEY, -- 2,147,483,647 rows is large enough for a toy system; bit.ly is 16x that
        created_at TIMESTAMP NOT NULL DEFAULT now(),
        key TEXT NOT NULL UNIQUE, -- just store the key, the full URL will be configured for a deployment
        target_url TEXT NOT NULL
      );
    SQL
  end

  def down
    execute <<-SQL
      DROP TABLE short_urls;
    SQL
  end
end
