# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# TODO: Split this seeder into multiple seeder files
# see: https://dev.to/gsgermanok/seeds-on-rails-the-best-way-to-create-and-feed-your-rails-database-1119

treasurer = Person.find_or_create_by!(name: "Maricel V. Felecio", position: "BPC Treasurer")
vice_moderator = Person.find_or_create_by!(name: "Ronelio T. Vallecera", position: "BPC Vice - Moderator")
moderator = Person.find_or_create_by!(name: "Felix Dusaran", position: "BPC Moderator")

statement = Statement.find_or_create_by!(
  month: :january,
  year: 2026,
  prepared_by: treasurer,
  approved_by: moderator,
  finalized_at: Date.today
)

# ============================================================
# Chart of Accounts
# ============================================================

mass_intention = Account.find_or_create_by!(code: "301", name: "Mass Intention", category: :income)
mass_offering = Account.find_or_create_by!(code: "303", name: "Mass Offering", category: :income)
other_receipts = Account.find_or_create_by!(code: "309", name: "Other Receipts", category: :income)

household_supplies = Account.find_or_create_by!(code: "505", name: "Household Supplies", category: :expense)
other_expenses = Account.find_or_create_by!(code: "516", name: "Other Expenses", category: :expense)
masses_scheduled = Account.find_or_create_by!(code: "512", name: "Masses Scheduled", category: :expense)
my_care_my_share = Account.find_or_create_by!(code: "512-A", name: "My Care, My Share", category: :expense)

# Transactions ==================================================

# Receipts ===
Transaction.find_or_create_by!(
  statement: statement,
  account: mass_intention,
  amount: 2881.64
)

Transaction.find_or_create_by!(
  statement: statement,
  account: mass_offering,
  amount: 881.64
)

Transaction.find_or_create_by!(
  statement: statement,
  account: other_receipts,
  amount: 281.64
)

# Expenses ===
Transaction.find_or_create_by!(
  statement: statement,
  account: household_supplies,
  amount: 2881.64
)

Transaction.find_or_create_by!(
  statement: statement,
  account: other_expenses,
  amount: 881.64
)

Transaction.find_or_create_by!(
  statement: statement,
  account: masses_scheduled,
  group_name: "Remittance",
  amount: 281.64
)

Transaction.find_or_create_by!(
  statement: statement,
  account: my_care_my_share,
  group_name: "Remittance",
  amount: 281.64
)
