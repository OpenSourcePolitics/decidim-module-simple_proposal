class RemoveAddRequireScopeToProposals < ActiveRecord::Migration[6.1]
  def change
    remove_column :decidim_proposals_proposals, :require_category, :boolean
  end
end