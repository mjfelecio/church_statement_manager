require 'rails_helper'

RSpec.describe "people/edit", type: :view do
  let(:person) {
    Person.create!(
      name: "MyString",
      position: "MyString"
    )
  }

  before(:each) do
    assign(:person, person)
  end

  it "renders the edit person form" do
    render

    assert_select "form[action=?][method=?]", person_path(person), "post" do

      assert_select "input[name=?]", "person[name]"

      assert_select "input[name=?]", "person[position]"
    end
  end
end
