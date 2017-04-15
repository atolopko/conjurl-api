class AddShortUrlRequestsTable < ActiveRecord::Migration[5.0]
  def up
    execute <<-SQL
      CREATE TABLE short_url_requests (
        id SERIAL PRIMARY KEY,
        short_url_id INT NOT NULL REFERENCES short_urls,
        requested_at TIMESTAMP NOT NULL,
        ip_address INET NOT NULL,
        referrer TEXT        
      );
    SQL
  end

  def down
    execute <<-SQL
      DROP TABLE short_url_requests;
    SQL
  end
end
