require 'rails_helper'

RSpec.describe "transactions/new", type: :view do
  before(:each) do
    assign(:transaction, Transaction.new(
      statement: nil,
      description: "MyString",
      group_name: "MyString",
      amount: "9.99",
      account: nil
    ))
  end

  it "renders new transaction form" do
    render

    assert_select "form[action=?][method=?]", transactions_path, "post" do

      assert_select "input[name=?]", "transaction[statement_id]"

      assert_select "input[name=?]", "transaction[description]"

      assert_select "input[name=?]", "transaction[group_name]"

      assert_select "input[name=?]", "transaction[amount]"

      assert_select "input[name=?]", "transaction[account_id]"
    end
  end
end
