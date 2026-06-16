require 'rails_helper'

RSpec.describe "chapels/new", type: :view do
  before(:each) do
    assign(:chapel, Chapel.new(
      name: "MyString",
      address: "MyText"
    ))
  end

  it "renders new chapel form" do
    render

    assert_select "form[action=?][method=?]", chapels_path, "post" do

      assert_select "input[name=?]", "chapel[name]"

      assert_select "textarea[name=?]", "chapel[address]"
    end
  end
end
