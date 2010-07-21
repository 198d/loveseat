class Hash
  def to_query
    components = self.map do |k,v|
      [URI.escape(k.to_s), URI.escape(v.to_s)].join('=')
    end
    components.join("&")
  end
end
