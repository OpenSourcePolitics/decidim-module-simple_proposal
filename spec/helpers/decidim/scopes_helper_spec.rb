# frozen_string_literal: true

require "spec_helper"

module Decidim
  describe ScopesHelper, type: :helper do
    describe "scopes_picker_tag" do
      let(:scope) { create(:scope) }

      it "works wrong" do
        actual = helper.scopes_picker_tag("my_scope_input", scope.id)

        expected = <<~HTML
          <div id="my_scope_input" class="data-picker picker-single" data-picker-name="my_scope_input">
            <div class="picker-values">
              <div>
                <a class="" href="/scopes/picker?current=#{scope.id}&amp;field=my_scope_input" data-picker-value="#{scope.id}">
                  #{scope.name["en"]} (#{decidim_escape_translated(scope.scope_type.name)})
                </a>
              </div>
            </div>
            <div class="picker-prompt">
              <a href="/scopes/picker?field=my_scope_input" role="button" aria-label="Select a scope (currently: Global scope)">Global scope</a>
            </div>
          </div>
        HTML

        expect(actual).to have_equivalent_markup_to(expected)
      end
    end
    describe "#ancestors" do
        let(:organization_1) { create(:organization) }
        let(:organization_2) { create(:organization) }

        let(:scope_1_o_1) { create(:scope, organization: organization_1)}
        let(:scope_2_o_1) { create(:scope, organization: organization_1)}
        let(:scope_1_o_2) { create(:scope, organization: organization_2)}
        let(:scope_2_o_2) { create(:scope, organization: organization_2)}

        it "returns only the scopes for the current organization" do
          allow(helper).to receive(:current_organization).and_return(organization_1)
          result = helper.send(:ancestor)
          expect(result).to match_array([:scope_1_o_1,:scope_2_o_1])
          expect(result).not_to include(:scope_1_o_2, :scope_2_o_2)
        end
      end
  end
end
