# frozen_string_literal: true

module Decidim
  module SimpleProposal
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::SimpleProposal

      # Allow admins to set the 'Scope' and 'Category' fields as required or optional in the decidim-proposal creation form
      initializer "decidim_simple_proposal.proposal_component_settings" do
        component = Decidim.find_component_manifest(:proposals)
        component.settings(:global) do |settings|
          settings.attribute :require_category, type: :boolean, default: Decidim::SimpleProposal.require_category
          settings.attribute :require_scope, type: :boolean, default: Decidim::SimpleProposal.require_scope
        end
      end
      initializer "decidim_proposals.overrides" do |app|
        app.config.to_prepare do
          Decidim::Proposals::ProposalsController.include Decidim::SimpleProposal::ProposalsControllerOverride
          Decidim::Proposals::ProposalForm.include Decidim::SimpleProposal::ProposalFormOverride
          Decidim::ScopesHelper.include Decidim::SimpleProposal::ScopesHelperOverride

          Decidim::Proposals::Admin::ProposalsController.include Decidim::SimpleProposal::Admin::ProposalsControllerOverride

          # Allow admins to split & merge proposals more freely
          Decidim::Proposals::Admin::ProposalsForkForm.include Decidim::SimpleProposal::Admin::ProposalForkFormOverride
          Decidim::Proposals::Admin::SplitProposals.include Decidim::SimpleProposal::Admin::SplitProposalsOverride
          Decidim::Proposals::Admin::MergeProposals.include Decidim::SimpleProposal::Admin::MergeProposalsOverride
          Decidim::Proposals::Admin::Permissions.include Decidim::SimpleProposal::Admin::PermissionOverrides

          # Fix attachments (images as documents), should not be needed after #8681
          Decidim::Proposals::UpdateProposal.include Decidim::SimpleProposal::UpdateProposalOverride
        end
      end
    end
  end
end
