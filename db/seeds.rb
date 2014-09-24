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

puts "0 users created."
puts "#{Register.count} registers created."
puts "#{Entry.count} register entries created."
puts "0 budgets created."
puts "0 budget items created."
puts "0 categories created."