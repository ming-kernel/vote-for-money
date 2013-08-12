# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.create(name: 'admin', 
            password: 'liyuhui', 
            password_confirmation: 'liyuhui', 
            last_active: Time.now,
            earnings: 0,
            round_id: 0)

Admin.create(stop: false)

# 300.times do |i|
#   User.create(name: "robot_#{i + 1}", 
#               password: '123',
#               password_confirmation: '123',
#               last_active: Time.now,
#               earnings: 0,
#               round_id: 0)
# end
