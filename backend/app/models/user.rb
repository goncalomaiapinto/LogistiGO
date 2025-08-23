class User < ApplicationRecord
  belongs_to :company

  validates :name, :email, :role, presence: true
  validates :email, uniqueness: true
  validates :role, inclusion: { in: %w[admin user] }
end
