module Roachclip
  module ClassMethods

    def roachclip(name, options = {})
      roachclip_attachment        = Attachment.new(name, options)
      self.roachclip_attachments  = roachclip_attachments.dup.add(roachclip_attachment)

      roachclip_attachment.joint_attachment_names.each do |attachment_name|
        self.attachment attachment_name
      end

      before_save :process_roachclip_attachments
      before_save :destroy_nil_roachclip_attachments
    end

  end
end
