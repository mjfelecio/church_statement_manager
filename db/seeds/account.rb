# === Income Accounts ===
Account.find_or_create_by!(code: "301") do |a|
  a.name = "Mass Intention"
  a.category = :income
end

Account.find_or_create_by!(code: "302") do |a|
  a.name = "Mass Collection"
  a.category = :income
end

Account.find_or_create_by!(code: "303") do |a|
  a.name = "Mass Offering"
  a.category = :income
end

Account.find_or_create_by!(code: "304") do |a|
  a.name = "Donation"
  a.category = :income
end

Account.find_or_create_by!(code: "305") do |a|
  a.name = "Takgay"
  a.category = :income
end

Account.find_or_create_by!(code: "306") do |a|
  a.name = "Subsidy From PFC Office"
  a.category = :income
end

Account.find_or_create_by!(code: "306-A") do |a|
  a.name = "Clan Offering"
  a.category = :income
end

Account.find_or_create_by!(code: "307") do |a|
  a.name = "My Care My Share"
  a.category = :income
end

Account.find_or_create_by!(code: "308") do |a|
  a.name = "Other Receipts"
  a.category = :income
end

Account.find_or_create_by!(code: "309") do |a|
  a.name = "Interest Income"
  a.category = :income
end

# === Expense Accounts ===
Account.find_or_create_by!(code: "501") do |a|
  a.name = "Travelling Expense"
  a.category = :expense
end

Account.find_or_create_by!(code: "502") do |a|
  a.name = "Training Expenses"
  a.category = :expense
end

Account.find_or_create_by!(code: "503") do |a|
  a.name = "Apostolate Expenses"
  a.category = :expense
end

Account.find_or_create_by!(code: "504") do |a|
  a.name = "Office Supplies & Materials"
  a.category = :expense
end

Account.find_or_create_by!(code: "505") do |a|
   a.name = "Household Supplies"
   a.category = :expense
end

Account.find_or_create_by!(code: "506") do |a|
  a.name = "Chapel Supplies"
  a.category = :expense
end

Account.find_or_create_by!(code: "507") do |a|
  a.name = "Water Expenses"
  a.category = :expense
end

Account.find_or_create_by!(code: "508") do |a|
  a.name = "Electricity Expenses"
  a.category = :expense
end

Account.find_or_create_by!(code: "509") do |a|
  a.name = "Land Improvement"
  a.group = "Repair & Maintenance"
  a.category = :expense
end

Account.find_or_create_by!(code: "510") do |a|
  a.name = "Building"
  a.group = "Repair & Maintenance"
  a.category = :expense
end

Account.find_or_create_by!(code: "511") do |a|
  a.name = "Equipment"
  a.group = "Repair & Maintenance"
  a.category = :expense
end

Account.find_or_create_by!(code: "512") do |a|
  a.name = "Mass Scheduled"
  a.group = "Remittance"
  a.category = :expense
end

Account.find_or_create_by!(code: "512-A") do |a|
  a.name = "My Care My Share"
  a.group = "Remittance"
  a.category = :expense
end

Account.find_or_create_by!(code: "513") do |a|
  a.name = "Representation Expenses"
  a.category = :expense
end

Account.find_or_create_by!(code: "514") do |a|
  a.name = "Charity"
  a.category = :expense
end

Account.find_or_create_by!(code: "515") do |a|
  a.name = "Food Supplies Expenses"
  a.category = :expense
end

Account.find_or_create_by!(code: "516") do |a|
  a.name = "Other Expenses"
  a.category = :expense
end

puts "-> Accounts seeded."
