require 'spec_helper'

describe RelationshipsController do
  let(:user) { FactoryGirl.create(:user) }
  let(:other_user) { FactoryGirl.create(:user) }

  before { sign_in user }

  describe "creating a relationship with Ajax" do
    it "decrement the Relationship count" do
      expect { xhr :post, :create, relationship: { followed_id: other_user.id } }.to change(Relationship, :count).by(1)
    end
  end

  describe "destroying a relationship with Ajax" do
    before { user.follow!(other_user) }
    let(:relationship) { user.relationships.find_by_followed_id(other_user) }

    it "should destroy a relationship using Ajax" do
      expect { xhr :delete, :destroy, id: relationship.id }.to change(Relationship, :count).by(-1)
    end
  end
end
