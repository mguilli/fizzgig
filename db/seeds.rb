register = Register.create(
  name: "Citizens",
  acctnumber: "1988",
  user_id: 1
  )

Entry.get_citizens_data(register)

puts "0 users created."
puts "#{Register.count} registers created."
puts "#{Entry.count} register entries created."
puts "0 budgets created."
puts "0 budget items created."
puts "0 categories created."