module Roachclip
  module ClassMethods

    def roachclip(name, options = {})
      roachclip_attachment        = Attachment.new(name, options)
      self.roachclip_attachments  = roachclip_attachments.dup.add(roachclip_attachment)

      roachclip_attachment.joint_attachment_names.each do |attachment_name, attachment_accessor_name|
        if options[:readonly]
          self.attachment attachment_name, readonly: true, accessor_name: attachment_accessor_name
        else
          self.attachment attachment_name, accessor_name: attachment_accessor_name
        end

        self.send(:define_method, "#{attachment_accessor_name}_path") do
          id = self.send(attachment_accessor_name).id
          top_doc = self.respond_to?(:_parent_document) ? self._parent_document : self
          ts = (Time.parse(top_doc.attributes['updated_at'].to_s) rescue Time.now).to_i
          collection = self.joint_collection_name || 'fs'
          id ? (roachclip_attachment.path % [collection, id.to_s, ts]).chomp('-') : nil
        end
      end

      unless options[:readonly]
        validates_presence_of name if roachclip_attachment.required?

        before_save :process_roachclip_attachments
        before_save :destroy_nil_roachclip_attachments
      end
    end

    def validates_roachclip(*args)
      validates_presence_of args
    end

  end
end
