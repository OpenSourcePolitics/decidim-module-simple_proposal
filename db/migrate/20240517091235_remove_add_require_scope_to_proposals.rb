# frozen_string_literal: true

class RemoveAddRequireScopeToProposals < ActiveRecord::Migration[6.1]
  def change
    remove_column :decidim_proposals_proposals, :require_scope, :boolean
  end
end
