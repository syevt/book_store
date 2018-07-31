class Review < ApplicationRecord
  belongs_to(:book)
  belongs_to(:user)

  scope(:approved, -> { where(state: 'approved') })
end
