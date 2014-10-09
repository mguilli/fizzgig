start = Time.now

testuser = User.create(
  first_name: 'Test',
  last_name: 'User',
  email: 'test@example.org',
  password: 'password'
  )

budget = Budget.create(user_id: testuser.id, start_date: Date.new(2100))

register = testuser.registers.create(
  name: "Citizens",
  acctnumber: "1988",
  startbalance_cents: 67_72
  )

Entry.get_excel_seed_data('Citizens', 5, 16, register.id)

register = testuser.registers.create(
  name: "Regions",
  acctnumber: "7985",
  startbalance_cents: 300_00
  )

Entry.get_excel_seed_data('Regions', 4, 18, register.id)

register = testuser.registers.create(
  name: "Test",
  acctnumber: "3333",
  startbalance_cents: 1_00
  )

Entry.get_excel_seed_data('Test', 5, 16, register.id)


DefaultItem.set_default_seed('DefaultItems', 3, 27, budget.id)
DefaultChange.set_change_seed('DefaultItems', 3, 7, budget.id)

range = (testuser.registers.pluck(:start_date).min.beginning_of_month .. Date.today).select {|x| x.day == 1}

range.each do |x|
  m = budget.months.find_or_create_by(date: x)
  m.write_defaults_to_items(budget)
  puts 'Month created and filled!'
end

finish = Time.now
duration = (finish - start).round(2)

puts " "
puts "Total time: #{duration} seconds."
puts " "
puts "#{User.count} users created."
puts "#{Register.count} registers created."
puts "#{Entry.count} register entries created."
puts "#{Budget.count} budgets created."
puts "#{DefaultItem.count} default budget items created."
puts "#{DefaultChange.count} default changes created."
puts "#{Item.count} items created"
puts "#{Month.count} months created."