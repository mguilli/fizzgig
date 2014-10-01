class Budget < ActiveRecord::Base
  has_many :default_items
  belongs_to :user
end
