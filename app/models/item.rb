class Item < ActiveRecord::Base
  belongs_to :month

  monetize :debit_cents
  monetize :credit_cents
end
