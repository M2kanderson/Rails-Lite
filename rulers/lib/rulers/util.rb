module Rulers
  def self.to_underscore(string)
    #turn double colons to slashes
    #replaces any two or more consecutive capital letters followed
    #by a lowercase letter with \1_\2 i.e. HELLOWord => HELLO_world
    #replaces lowercase-number-uppercase with lowercase-number-underscore-uppercase
    #i.e. hello20Whee => hello20_Whee
    #replaces all dashes with underscores, and converts everything to lowercase
    string.gsub(/::/, '/').
    gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').
    gsub(/([a-z\d])([A-Z])/,'\1_\2').
    tr("-", "_").
    downcase
  end
end
