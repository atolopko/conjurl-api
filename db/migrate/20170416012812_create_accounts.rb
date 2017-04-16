class CreateAccounts < ActiveRecord::Migration[5.0]
  def up
    execute <<-SQL
      CREATE TABLE accounts (
        id SERIAL PRIMARY KEY,
        created_at TIMESTAMP NOT NULL DEFAULT now(),
        updated_at TIMESTAMP,
        name TEXT NOT NULL UNIQUE,
        public_identifier UUID NOT NULL UNIQUE
      );

      ALTER TABLE short_urls ADD COLUMN account_id INT NULL REFERENCES accounts;
      CREATE INDEX short_urls_account_id_ndx ON short_urls (account_id) WHERE account_id IS NOT NULL;
    SQL
  end

  def down
    execute <<-SQL
      ALTER TABLE short_urls DROP COLUMN account_id;

      DROP TABLE accounts;
    SQL
  end
end
