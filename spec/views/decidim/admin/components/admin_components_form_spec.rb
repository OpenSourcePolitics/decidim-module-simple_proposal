# frozen_string_literal: true

require "spec_helper"

describe "decidim/admin/components/_form.html.erb", type: :view do
  let(:organization) { create(:organization) }
  let(:participatory_process) { create(:participatory_process, organization: organization) }
  let(:component) { create(:proposal_component, participatory_space: participatory_process) }

  before do
    allow(view).to receive(:current_organization).and_return(organization)
    allow(view).to receive(:current_participatory_space).and_return(participatory_process)

    render partial: "decidim/admin/components/form", locals: { component: component, title: "Test Title" }
  end

  it "renders the require_category checkbox" do
    expect(rendered).to have_selector("input[type=checkbox][name='component[settings][require_category]']")
  end

  it "renders the require_scope checkbox" do
    expect(rendered).to have_selector("input[type=checkbox][name='component[settings][require_scope]']")
  end
end
