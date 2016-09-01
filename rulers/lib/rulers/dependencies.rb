class Object
  @seen = {}
  def self.const_missing(c)
    if(@seen[c])
      return nil
    end
    @seen[c] = true
    require Rulers.to_underscore(c.to_s)
    Object.const_get(c)
  end
end
