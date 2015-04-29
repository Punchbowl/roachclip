require 'set'
require 'active_support/concern'

module Roachclip
  extend ActiveSupport::Concern

  included do
    plugin Joint
    class_attribute :roachclip_attachments
    self.roachclip_attachments = Set.new
  end

end

require 'roachclip/version'
require 'roachclip/class_methods'
require 'roachclip/instance_methods'
require 'roachclip/attachment'
require 'roachclip/style'
