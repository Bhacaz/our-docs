class User < ApplicationRecord
  has_many :sites, dependent: :destroy
end
