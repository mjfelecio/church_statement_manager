require 'rails_helper'

RSpec.describe "statements/edit", type: :view do
  let(:statement) {
    Statement.create!(
      chapel: nil,
      month: 1,
      year: 1,
      beginning_balance: "9.99",
      ending_balance: "9.99",
      prepared_by: nil,
      approved_by: nil
    )
  }

  before(:each) do
    assign(:statement, statement)
  end

  it "renders the edit statement form" do
    render

    assert_select "form[action=?][method=?]", statement_path(statement), "post" do

      assert_select "input[name=?]", "statement[chapel_id]"

      assert_select "input[name=?]", "statement[month]"

      assert_select "input[name=?]", "statement[year]"

      assert_select "input[name=?]", "statement[beginning_balance]"

      assert_select "input[name=?]", "statement[ending_balance]"

      assert_select "input[name=?]", "statement[prepared_by_id]"

      assert_select "input[name=?]", "statement[approved_by_id]"
    end
  end
end
