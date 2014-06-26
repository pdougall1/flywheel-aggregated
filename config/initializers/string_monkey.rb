class String

  def dot_to_underscore
    self.split('.').join("_")
  end

  def to_attr_name append = nil
    str = self.dot_to_underscore.
      gsub(/::/, '/').
      gsub(/\S\.\S/, "_").
      gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').
      gsub(/([a-z\d])([A-Z])/, '\1_\2').
      gsub("-", "_").
      gsub(" ", "_").
      gsub(/[\W]/, '')

      str = str + append if append.present?

      str.downcase.to_sym
  end

  def to_constant_string
    str = self.dot_to_underscore.
      gsub(/::/, '/').
      gsub(/\S\.\S/, "_").
      gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').
      gsub(/([a-z\d])([A-Z])/, '\1_\2').
      gsub("-", "_").
      gsub(" ", "_").
      gsub(/[\W]/, '')
    str.split('_').map(&:capitalize).join
  end

end