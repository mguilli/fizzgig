json.array!(@default_changes) do |default_change|
  json.extract! default_change, :id, :day, :name, :debit_cents, :credit_cents, :endon, :month_changed, :default_item_id
  json.url default_change_url(default_change, format: :json)
end
