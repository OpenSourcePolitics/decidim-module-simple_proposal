# frozen_string_literal: true
require "spec_helper"

module Decidim
  describe ScopesHelper, type: :helper do

    describe "#ancestors" do
      let(:first_organization) { create(:organization) }
      let(:second_organization) { create(:organization) }

      let!(:first_scope) { create(:scope, organization: first_organization) }
      let!(:second_scope) { create(:scope, organization: first_organization) }
      let!(:third_scope) { create(:scope, organization: second_organization) }
      let!(:fourth_scope) { create(:scope, organization: second_organization) }

      it "returns only the scopes for the current organization" do
        allow(helper).to receive(:current_organization).and_return(first_organization)

        result = helper.send(:ancestors)

        expect(result).to match_array([first_scope, second_scope])
        expect(result).not_to include(third_scope, fourth_scope)
      end
    end
  end
end
