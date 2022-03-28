# frozen_string_literal: true

require "decidim/concerns/simple_proposal/autocomplete_override"

module Decidim
  module SimpleProposal
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::SimpleProposal

      initializer "decidim_proposals.overrides" do |app|
        app.config.to_prepare do
          Decidim::Proposals::ProposalsController.include Decidim::SimpleProposal::ProposalsControllerOverride
          Decidim::Proposals::ProposalForm.include Decidim::SimpleProposal::ProposalFormOverride
          Decidim::ScopesHelper.include Decidim::SimpleProposal::ScopesHelperOverride

          Decidim::Proposals::Admin::ProposalsController.include Decidim::SimpleProposal::Admin::ProposalsControllerOverride

          # Remove after https://github.com/decidim/decidim/pull/8762
          Decidim::Map::Autocomplete::FormBuilder.include Decidim::SimpleProposal::AutocompleteOverride

          # Allow admins to split & merge proposals more freely
          Decidim::Proposals::Admin::ProposalsForkForm.include Decidim::SimpleProposal::Admin::ProposalForkFormOverride
          Decidim::Proposals::Admin::SplitProposals.include Decidim::SimpleProposal::Admin::SplitProposalsOverride
          Decidim::Proposals::Admin::MergeProposals.include Decidim::SimpleProposal::Admin::MergeProposalsOverride
          Decidim::Proposals::Admin::Permissions.include Decidim::SimpleProposal::Admin::PermissionOverrides

          # Fix attachments, remove after #8681
          Decidim::Proposals::UpdateProposal.include Decidim::SimpleProposal::UpdateProposalOverride
        end
      end
    end
  end
end
