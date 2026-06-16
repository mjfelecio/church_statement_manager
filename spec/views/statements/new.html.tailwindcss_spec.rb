require 'rails_helper'

RSpec.describe "statements/new", type: :view do
  before(:each) do
    assign(:statement, Statement.new(
      chapel: nil,
      month: 1,
      year: 1,
      beginning_balance: "9.99",
      ending_balance: "9.99",
      prepared_by: nil,
      approved_by: nil
    ))
  end

  it "renders new statement form" do
    render

    assert_select "form[action=?][method=?]", statements_path, "post" do

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
