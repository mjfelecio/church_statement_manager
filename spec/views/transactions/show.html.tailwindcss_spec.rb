require 'rails_helper'

RSpec.describe "transactions/show", type: :view do
  before(:each) do
    assign(:transaction, Transaction.create!(
      statement: nil,
      description: "Description",
      group_name: "Group Name",
      amount: "9.99",
      account: nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/Description/)
    expect(rendered).to match(/Group Name/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(//)
  end
end
