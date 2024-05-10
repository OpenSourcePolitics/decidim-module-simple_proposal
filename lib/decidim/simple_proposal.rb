# frozen_string_literal: true

require_relative "simple_proposal/version"
require_relative "simple_proposal/engine"

module Decidim
  module SimpleProposal
    include ActiveSupport::Configurable

    config_accessor :require_scope do
      false
    end

    config_accessor :require_category do
      false
    end
  end
end
