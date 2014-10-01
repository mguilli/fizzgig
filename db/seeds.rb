register = Register.create(
  name: "Citizens",
  acctnumber: "1988",
  user_id: 1,
  startbalance_cents: 67_72
  )

Entry.get_excel_seed_data('Citizens', 5, 16, register.id)

register = Register.create(
  name: "Regions",
  acctnumber: "7985",
  user_id: 1,
  startbalance_cents: 300_00
  )

Entry.get_excel_seed_data('Regions', 4, 18, register.id)

register = Register.create(
  name: "Test",
  acctnumber: "3333",
  user_id: 1,
  startbalance_cents: 1_00
  )

Entry.get_excel_seed_data('Test', 5, 16, register.id)

budget = Budget.create(user_id: 1)

DefaultItem.set_default_seed('DefaultItems', 2, 26, budget.id)

puts "0 users created."
puts "#{Register.count} registers created."
puts "#{Entry.count} register entries created."
puts "#{Budget.count} budgets created."
puts "#{DefaultItem.count} default budget items created."
puts "0 categories created."