# frozen_string_literal: true

require "spec_helper"

module Decidim
  describe ScopesHelper, type: :helper do
    include ActionView::Helpers::SanitizeHelper
    include ActionView::Helpers::TagHelper
    include Decidim::TranslatableAttributes
    include Decidim::SanitizeHelper
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
