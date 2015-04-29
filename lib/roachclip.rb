require 'set'
require 'active_support/concern'

module Roachclip
  extend ActiveSupport::Concern

  included do
    plugin Joint
    class_attribute :roaches
    self.roaches = Set.new
  end

end

require 'roachclip/version'
require 'roachclip/class_methods'
require 'roachclip/instance_methods'
