class Register < ActiveRecord::Base
  has_many :entries

  monetize :startbalance_cents
end
