puts "[Seeder] Seeding database."

load Rails.root.join("db/seeds/account.rb")
load Rails.root.join("db/seeds/person.rb")

puts "[Seeder] Database seeded successfully."
