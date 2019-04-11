module Roachclip
  class Attachment
    DEFAULTS = {
      styles:         {},
      default_style:  :original,
      path:           "/gridfs/fs/%s-%s",
      required:       false
    }

    attr_accessor :name, :accessor_name, :options, :styles

    def initialize(name, options = {})
      self.options = options.symbolize_keys.reverse_merge(DEFAULTS)
      self.name = name.to_sym
      self.accessor_name = self.options[:accessor_name] || name.to_sym

      self.styles  = self.options[:styles].map do |key, opts|
        Style.new(key, opts)
      end
    end

    def ==(rhs)
      name == rhs.name
    end

    def default_style_name
      options[:default_style]
    end

    def path
      options[:path]
    end

    def joint_attachment_names
      [[name, accessor_name ]] + styles.select { |style| style.name != default_style_name }.map { |style| ["#{name}_#{style.name}".to_sym, "#{accessor_name}_#{style.name}".to_sym] }
    end

    def required?
      !!options[:required]
    end
  end
end
