class Budget < ActiveRecord::Base
  belongs_to :user
  has_many :default_items
  has_many :months
end
