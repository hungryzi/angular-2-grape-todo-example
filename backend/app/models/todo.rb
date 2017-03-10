class Todo < ApplicationRecord
  validates :description, presence: true
  validates :complete, inclusion: { in: [true, false] }
end
