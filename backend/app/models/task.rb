class Task < ApplicationRecord
  belongs_to :company
  belongs_to :user
  
  validates :title, :status, presence: true
  validates :status, inclusion: { in: %w[pending in_progress done] }
end