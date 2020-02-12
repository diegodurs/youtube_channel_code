require 'active_support/core_ext/string'
require 'securerandom'

require 'nuago/generic_event'
require 'nuago/event_store'

require 'byebug'
require 'pp'

module Nuago
  def self.new_uuid
    SecureRandom.uuid.gsub('-', '')
  end
end
