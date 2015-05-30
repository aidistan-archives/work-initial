class User < ActiveRecord::Base
  has_many :records
  validates :openid, presence: true
end
