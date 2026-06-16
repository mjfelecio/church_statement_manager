require 'rails_helper'

RSpec.describe "people/index", type: :view do
  before(:each) do
    assign(:people, [
      Person.create!(
        name: "Name",
        position: "Position"
      ),
      Person.create!(
        name: "Name",
        position: "Position"
      )
    ])
  end

  it "renders a list of people" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Position".to_s), count: 2
  end
end
