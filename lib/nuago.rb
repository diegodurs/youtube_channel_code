require 'active_support/core_ext/string'
require 'securerandom'
require 'nuago/event_store'
require 'nuago/generic_event'
require 'nuago/reducer'

module Nuago

  def self.new_uuid
    SecureRandom.uuid.gsub('-', '')
  end

  def self.now
    Time.now
  end
end
