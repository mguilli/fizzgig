class Register < ActiveRecord::Base
  has_many :entries
  belongs_to :user

  monetize :startbalance_cents
  monetize :available_balance_cents
  monetize :cleared_balance_cents

  def entries_ranked
    self.entries.order(rank: :desc)  
  end

  def calc_available_balance_cents
    self.entries_ranked.first.balance_cents
  end

  def calc_cleared_balance_cents
    diff = self.entries.where(cleared: false).sum(:credit_cents) -
            self.entries.where(cleared: false).sum(:debit_cents)
    s = self.calc_available_balance_cents - diff
  end
end
