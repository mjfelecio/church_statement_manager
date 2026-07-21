class BackupService
  VERSION = 1
  APP_VERSION = "1.0.0"

  REQUIRED_COLLECTIONS = %w[people accounts statements transactions].freeze

  class ImportError < StandardError; end

  def self.export
    data = {
      version: VERSION,
      app_version: APP_VERSION,
      rails_version: Rails.version,
      exported_at: Time.current.iso8601,
      data: {
        people: export_people,
        accounts: export_accounts,
        statements: export_statements,
        transactions: export_transactions
      }
    }

    JSON.pretty_generate(data)
  end

  def self.validate(json_string)
    parsed = JSON.parse(json_string)
    validate_structure!(parsed)
    parsed
  end

  def self.import(json_string)
    parsed = JSON.parse(json_string)
    validate_structure!(parsed)

    ApplicationRecord.transaction do
      clear_existing_data!

      people_map = import_people(parsed["data"]["people"])
      accounts_map = import_accounts(parsed["data"]["accounts"])
      statements_map = import_statements(parsed["data"]["statements"], people_map)
      import_transactions(parsed["data"]["transactions"], accounts_map, statements_map)
    end

    true
  rescue JSON::ParserError => e
    raise ImportError, "Invalid JSON: #{e.message}"
  rescue ActiveRecord::RecordInvalid => e
    raise ImportError, "Database error: #{e.message}"
  rescue ImportError
    raise
  rescue => e
    raise ImportError, "Unexpected error: #{e.message}"
  end

  private

  def self.export_people
    Person.all.map do |p|
      { "name" => p.name, "position" => p.position }
    end
  end

  def self.export_accounts
    Account.all.map do |a|
      {
        "code" => a.code,
        "name" => a.name,
        "group" => a.group,
        "description" => a.description,
        "category" => a.category
      }
    end
  end

  def self.export_statements
    Statement.all.map do |s|
      {
        "month" => s.month,
        "year" => s.year,
        "initial_balance" => s.initial_balance&.to_s,
        "prepared_by_name" => s.prepared_by.name,
        "approved_by_name" => s.approved_by.name,
        "finalized_at" => s.finalized_at&.iso8601,
        "created_at" => s.created_at.iso8601,
        "updated_at" => s.updated_at.iso8601
      }
    end
  end

  def self.export_transactions
    Transaction.all.map do |t|
      {
        "account_code" => t.account.code,
        "statement_month" => t.statement.month,
        "statement_year" => t.statement.year,
        "description" => t.description,
        "amount" => t.amount.to_s,
        "created_at" => t.created_at.iso8601,
        "updated_at" => t.updated_at.iso8601
      }
    end
  end

  def self.validate_structure!(parsed)
    unless parsed.is_a?(Hash)
      raise ImportError, "Backup must be a JSON object"
    end

    unless parsed["version"] == VERSION
      raise ImportError, "Unsupported backup version: #{parsed["version"] || "unknown"}. Expected version #{VERSION}."
    end

    unless parsed["data"].is_a?(Hash)
      raise ImportError, "Backup is missing the 'data' field"
    end

    missing = REQUIRED_COLLECTIONS.select { |c| !parsed["data"][c].is_a?(Array) }
    if missing.any?
      raise ImportError, "Backup is missing required collections: #{missing.join(", ")}"
    end
  end

  def self.clear_existing_data!
    Transaction.delete_all
    Statement.delete_all
    Account.delete_all
    Person.delete_all
  end

  def self.import_people(people_data)
    people_data.each_with_object({}) do |attrs, map|
      person = Person.create!(
        name: attrs["name"],
        position: attrs["position"]
      )
      map[attrs["name"]] = person
    end
  end

  def self.import_accounts(accounts_data)
    accounts_data.each_with_object({}) do |attrs, map|
      account = Account.create!(
        code: attrs["code"],
        name: attrs["name"],
        group: attrs["group"],
        description: attrs["description"],
        category: attrs["category"]
      )
      map[attrs["code"]] = account
    end
  end

  def self.import_statements(statements_data, people_map)
    statements_data.each_with_object({}) do |attrs, map|
      prepared_by = people_map[attrs["prepared_by_name"]]
      approved_by = people_map[attrs["approved_by_name"]]

      unless prepared_by && approved_by
        raise ImportError, "Statement #{attrs["month"]}/#{attrs["year"]} references unknown person"
      end

      statement = Statement.new(
        month: attrs["month"],
        year: attrs["year"],
        prepared_by: prepared_by,
        approved_by: approved_by,
        finalized_at: attrs["finalized_at"],
        created_at: attrs["created_at"],
        updated_at: attrs["updated_at"]
      )
      statement.save!(validate: false)

      if attrs["initial_balance"].present?
        statement.update_column(:initial_balance, attrs["initial_balance"])
      end

      map[[ attrs["month"], attrs["year"] ]] = statement
    end
  end

  def self.import_transactions(transactions_data, accounts_map, statements_map)
    transactions_data.each do |attrs|
      account = accounts_map[attrs["account_code"]]
      statement = statements_map[[ attrs["statement_month"], attrs["statement_year"] ]]

      unless account && statement
        missing = []
        missing << "account '#{attrs["account_code"]}'" unless account
        missing << "statement #{attrs["statement_month"]}/#{attrs["statement_year"]}" unless statement
        raise ImportError, "Transaction references unknown #{missing.join(" and ")}"
      end

      Transaction.create!(
        account: account,
        statement: statement,
        description: attrs["description"],
        amount: attrs["amount"],
        created_at: attrs["created_at"],
        updated_at: attrs["updated_at"]
      )
    end
  end
end
