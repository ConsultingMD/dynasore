require 'active_support/core_ext/module/delegation.rb'

require 'dynasore/binary_attribute.rb'
require 'dynasore/binary_string.rb'
require 'dynasore/configuration.rb'
require 'dynasore/version.rb'

module Dynasore
  def self.configure
    yield Configuration.instance
  end
end
