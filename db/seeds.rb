# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Admin.delete_all()
Admin.create(stop: false)

Letters = ('a'..'z').to_a
Passwords = []

def generate_random_password()
  p = Letters.shuffle[0, 6].join
  while true
    matched = Passwords.select {|e| e == p}
    if matched.length == 0
      Passwords << p
      break
    else
      p = Letters.shuffle[0, 6].join
    end
  end
  p
end

300.times do |i|
  p = generate_random_password
  User.create(name: "player#{i + 1}", 
              plain_password: p,
              password: p,
              password_confirmation: p,
              last_active: Time.now,
              earnings: 0,
              round_id: 0)
end
