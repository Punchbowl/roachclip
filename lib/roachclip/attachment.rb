module Roachclip
  class Attachment
    attr_accessor :name, :options, :styles

    def initialize(name, options = {})
      self.name    = name.to_sym
      self.options = options.symbolize_keys

      self.styles  = self.options[:styles].map do |key, opts|
        Style.new(key, opts)
      end
    end

    def ==(rhs)
      name == rhs.name
    end

    def default_style_name
      options[:default_style] || :original
    end

    def joint_attachment_names
      [ name ] + styles.select { |style| style.name != default_style_name }.map { |style| "#{name}_#{style.name}" }
    end
  end
end
