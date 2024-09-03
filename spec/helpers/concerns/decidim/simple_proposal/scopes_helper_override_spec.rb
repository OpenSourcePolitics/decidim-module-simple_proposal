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

    describe "selected_scope method" do
      Object = Struct.new(:scope_id, :decidim_scope_id)
      Setting = Struct.new(:scope_id)
      Myform = Struct.new(:scope_id, :settings, :object)

      context "when form has a scope_id" do
        it "returns scope_id" do
          form = Myform.new(5, Setting.new(6), Object.new(7, 8))
          expect(selected_scope(form)).to eq(5)
        end
      end

      context "when form has no scope_id but has setting with scope_id" do
        it "returns the scope_id of settings" do
          form = Myform.new(nil, Setting.new(6), Object.new(7, 8))
          expect(selected_scope(form)).to eq(6)
        end
      end

      context "when form has no scope_id, no settings but has object with scope_id" do
        it "returns the scope_id of object" do
          form = Myform.new(nil, nil, Object.new(7, 8))
          expect(selected_scope(form)).to eq(7)
        end
      end

      context "when form has no scope_id, no settings but has object with decidim_scope_id and without scope_id" do
        # this is the case we added, which corresponds to project edit in admin
        it "returns the decidim_scope_id of object" do
          form = Myform.new(nil, nil, Object.new(nil, 8))
          expect(selected_scope(form)).to eq(8)
        end
      end
    end
  end
end
