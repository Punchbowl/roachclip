module Roachclip
  module ClassMethods

    def roachclip(name, options = {})
      options.symbolize_keys!
      name = name.to_sym

      self.roaches = roaches.dup.add(name)
    end

  end
end
