class User < ApplicationRecord
  has_many(:addresses, class_name: 'Ecomm::Address',
                       foreign_key: :customer_id, dependent: :destroy)
  has_many(:reviws, dependent: :destroy)
  has_one(:billing_address, -> { billing }, class_name: 'Ecomm::Address',
                                            foreign_key: :customer_id)

  devise(:database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:facebook])
end
