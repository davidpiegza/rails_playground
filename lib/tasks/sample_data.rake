
namespace :db do
  desc 'Fill database with sample data'
  task populate: :environment do
    Rake::Task['db:reset'].invoke
    admin = User.create!(name: 'David Piegza', email: 'david.piegza@web.de', password: 'foobar', password_confirmation: 'foobar')
    admin.toggle!(:admin)
    User.create!(name: 'Example User', email: 'user@example.com', password: 'foobar', password_confirmation: 'foobar')
    99.times do |n|
      name = Faker::Name.name
      email = "example-#{n+1}@example.com"
      password = 'password'
      User.create! name: name, email: email, password: password, password_confirmation: password
    end
  end
end