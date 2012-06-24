def symbolize_keys(hash)
  nh = {}
  hash.each_pair do |key,val|
    nh[key.to_sym] = val.is_a?(Hash) ? symbolize_keys(val) : val
  end
  nh
end
