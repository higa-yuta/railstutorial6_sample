
User.create!(name: "okinawa taro",
             email: 'okinawa@sample.com',
             password: 'password',
             password_confirmation: 'password',
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

99.times do |i|
  name = Faker::Name.name
  email = "#{i}_sample@sample.com"
  password = 'password'
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now)
end