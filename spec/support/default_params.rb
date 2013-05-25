require 'active_support/concern'

module DefaultParams
  extend ActiveSupport::Concern

  def process_with_default_params(action, parameters, session, flash, method)
    process_without_default_params(action, default_params.merge(parameters || {}), session, flash, method)
  end

  included do
    let(:default_params) { {} }
    alias_method_chain :process, :default_params
  end
end

RSpec.configure do |config|
  config.include(DefaultParams, :type => :controller)
end