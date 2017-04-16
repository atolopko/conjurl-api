class Account < ApplicationRecord

  before_validation :set_public_identifier

  validates :name, presence: true, uniqueness: true
  validates :public_identifier, presence: true, uniqueness: true

  has_many :short_urls
  
  private

  def set_public_identifier
    self.public_identifier ||= UUID.new.generate
  end
    
end
