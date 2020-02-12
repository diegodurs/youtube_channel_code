require 'active_support/core_ext/string'
require 'securerandom'

module Nuago

  def new_uuid
    SecureRandom.uuid.gsub('-', '')
  end

  def now
    Time.now
  end
end
