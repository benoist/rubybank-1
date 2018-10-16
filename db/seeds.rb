# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
users = %w[user1 user2 user3 user4]
users.each_with_index do |user, i|
  User.create!(
               name: user.humanize,
               email: "#{user.downcase}@rubybank.com",
               password: '123456'
              )
  BankAccount.create!(
                      user_id: i+1,
                      number: "ROR5BNK000#{i}",
                      balance: '2000'
                     )
end
