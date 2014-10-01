testuser = User.create(
  first_name: 'Test',
  last_name: 'User',
  email: 'test@example.org',
  password: 'password'
  )

register = testuser.registers.create(
  name: "Citizens",
  acctnumber: "1988"
  )

Entry.get_excel_seed_data('Citizens', 5, 16, register.id)

register = testuser.registers.create(
  name: "Regions",
  acctnumber: "7985"
  )

Entry.get_excel_seed_data('Regions', 4, 18, register.id)

register = testuser.registers.create(
  name: "Test",
  acctnumber: "3333",
  startbalance_cents: 1_00
  )

Entry.get_excel_seed_data('Test', 5, 16, register.id)

budget = Budget.create(user_id: testuser.id)

DefaultItem.set_default_seed('DefaultItems', 2, 26, budget.id)

puts "#{User.count} users created."
puts "#{Register.count} registers created."
puts "#{Entry.count} register entries created."
puts "#{Budget.count} budgets created."
puts "#{DefaultItem.count} default budget items created."
puts "0 categories created."