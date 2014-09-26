class Register < ActiveRecord::Base
  has_many :entries

  monetize :startbalance_cents

  def entries_ranked
    self.entries.order(rank: :desc)  
  end

  def available_balance
    self.entries_ranked.first.balance
  end

  def cleared_balance
    diff = self.entries.where(cleared: false).sum(:credit_cents) -
            self.entries.where(cleared: false).sum(:debit_cents)
    s = self.available_balance - Money.new(diff)
  end
end
