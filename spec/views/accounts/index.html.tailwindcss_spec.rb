require 'rails_helper'

RSpec.describe "accounts/index", type: :view do
  before(:each) do
    assign(:accounts, [
      Account.create!(
        code: "Code",
        name: "Name",
        description: "MyText",
        category: 2
      ),
      Account.create!(
        code: "Code",
        name: "Name",
        description: "MyText",
        category: 2
      )
    ])
  end

  it "renders a list of accounts" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Code".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
  end
end
