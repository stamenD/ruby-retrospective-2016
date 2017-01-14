class Hash
  def fetch_deep(path)
    path.split(".").reduce(self) do |memo, key|
      memo == nil ? nil : memo[key.to_i] || memo[key.to_sym] || memo[key]
    end
  end

  def reshape(shape)
    shape.map do |k, v|
      v.is_a?(Hash) ? [k, reshape(v)] : [k, fetch_deep(v)]
    end.to_h
  end
end 
class Array
  def reshape(shape)
    map { |element| element.reshape(shape) }
  end

  def fetch_deep(key_path)
    key, nested_key_path = key_path.split('.', 2)
    element = self[key.to_i]

    element.fetch_deep(nested_key_path) if element
  end
end