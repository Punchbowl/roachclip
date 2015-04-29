module Roachclip
  module ClassMethods

    def roachclip(name, options = {})
      roachclip_attachment = Attachment.new(name, options)
      self.roachclip_attachments = roachclip_attachments.dup.add(roachclip_attachment)

      # Add the Joint attachments
      self.attachment roachclip_attachment.name
      roachclip_attachment.styles.each do |style|
        self.attachment style.name
      end
    end

  end
end
