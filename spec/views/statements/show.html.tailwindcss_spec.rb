require 'rails_helper'

RSpec.describe "statements/show", type: :view do
  before(:each) do
    assign(:statement, Statement.create!(
      chapel: nil,
      month: 2,
      year: 3,
      beginning_balance: "9.99",
      ending_balance: "9.99",
      prepared_by: nil,
      approved_by: nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
