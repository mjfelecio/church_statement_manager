require "rails_helper"

RSpec.describe ChapelsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/chapels").to route_to("chapels#index")
    end

    it "routes to #new" do
      expect(get: "/chapels/new").to route_to("chapels#new")
    end

    it "routes to #show" do
      expect(get: "/chapels/1").to route_to("chapels#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/chapels/1/edit").to route_to("chapels#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/chapels").to route_to("chapels#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/chapels/1").to route_to("chapels#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/chapels/1").to route_to("chapels#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/chapels/1").to route_to("chapels#destroy", id: "1")
    end
  end
end
