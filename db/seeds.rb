register = Register.create(
  name: "Citizens",
  acctnumber: "1988",
  user_id: 1
  )

Entry.get_excel_seed_data('Citizens', 4, 13, register.id)

puts "0 users created."
puts "#{Register.count} registers created."
puts "#{Entry.count} register entries created."
puts "0 budgets created."
puts "0 budget items created."
puts "0 categories created."