class Budget < ActiveRecord::Base
  has_many :default_items
end
