require 'rails_helper'

RSpec.describe "chapels/index", type: :view do
  before(:each) do
    assign(:chapels, [
      Chapel.create!(
        name: "Name",
        address: "MyText"
      ),
      Chapel.create!(
        name: "Name",
        address: "MyText"
      )
    ])
  end

  it "renders a list of chapels" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
  end
end
