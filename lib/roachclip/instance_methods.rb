require 'tempfile'
require 'paperclip'

module Roachclip

  def process_roachclip_attachments
    roachclip_attachments.each do |roachclip_attachment|
      name                = roachclip_attachment.name
      default_style_name  = roachclip_attachment.default_style_name

      return unless assigned_attachments[name]

      src = Tempfile.new [ 'roachclip', name.to_s].join('-')
      src.write assigned_attachments[name].read
      src.close

      assigned_attachments[name].rewind

      roachclip_attachment.styles.each do |style|
        thumbnail = Paperclip::Thumbnail.new src, style.options
        tmp_file_name = thumbnail.make
        stored_file_name = send("#{name}_name").gsub(/\.(\w*)\Z/) { "_#{style.name}.#{$1}" }

        if style.name == default_style_name
          send "#{name}=", tmp_file_name
          send "#{name}_name=", stored_file_name
        else
          send "#{name}_#{style.name}=", tmp_file_name
          send "#{name}_#{style.name}_name=", stored_file_name
        end
      end
    end
  end

  def destroy_nil_roachclip_attachments
  end

end
