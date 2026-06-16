require 'rails_helper'

RSpec.describe "chapels/edit", type: :view do
  let(:chapel) {
    Chapel.create!(
      name: "MyString",
      address: "MyText"
    )
  }

  before(:each) do
    assign(:chapel, chapel)
  end

  it "renders the edit chapel form" do
    render

    assert_select "form[action=?][method=?]", chapel_path(chapel), "post" do

      assert_select "input[name=?]", "chapel[name]"

      assert_select "textarea[name=?]", "chapel[address]"
    end
  end
end
