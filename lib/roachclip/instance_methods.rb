require 'tempfile'
require 'paperclip'

module Roachclip

  def process_roachclip_attachments
    roachclip_attachments.each do |roachclip_attachment|
      name = roachclip_attachment.name

      return unless assigned_attachments[name]

      with_temp_file(name) do |src|
        roachclip_attachment.styles.each do |style|
          thumbnail = Paperclip::Thumbnail.new src, style.options
          tmp_file_name = thumbnail.make
          stored_file_name = send("#{name}_name").gsub(/\.(\w*)\Z/) { "_#{style.name}.#{$1}" }

          if style.name == roachclip_attachment.default_style_name
            send "#{name}=", tmp_file_name
            send "#{name}_name=", stored_file_name
          else
            send "#{name}_#{style.name}=", tmp_file_name
            send "#{name}_#{style.name}_name=", stored_file_name
          end
        end
      end
    end
  end

  def destroy_nil_roachclip_attachments
    roachclip_attachments.each do |roachclip_attachment|
      name = roachclip_attachment.name
      if nil_attachments.include?(name)
        roachclip_attachment.styles.each do |style|
          unless style.name == roachclip_attachment.default_style_name
            send "#{name}_#{style.name}=", nil
          end
        end
      end
    end
  end

  private

  def with_temp_file(name, &block)
    file = Tempfile.new ['roachclip', name.to_s].join('-')
    begin
      file.write assigned_attachments[name].read
      file.close
      assigned_attachments[name].rewind
      block.call(file)
    ensure
      file.close
      file.unlink
    end
  end

end
