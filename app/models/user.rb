class User < ApplicationRecord
  has_many :addresses, class_name: 'Ecomm::Address',
                       foreign_key: :customer_id, dependent: :destroy
  devise(:database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:facebook])
end
