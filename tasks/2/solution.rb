class Hash
  def find_type_of_key(source, key)
    return key.to_i if source.is_a?(Array) && source.fetch(key.to_i) { false }
    return key.to_i if source.is_a?(Hash) && source.key?(key.to_i)
    return key.to_sym if source.is_a?(Hash) && source.key?(key.to_sym)
    return key if source.is_a?(Hash) && source.key?(key)
    nil                
  end
  def fetch_deep_with_index(source, path_in_arr, index)
    if find_type_of_key(source, path_in_arr[index]) == nil
      return nil
    else
      key = find_type_of_key(source, path_in_arr[index])
    end
    return source[key] if index == path_in_arr.size - 1
    index += 1
    fetch_deep_with_index(source[key], path_in_arr, index)
  end
  
  def fetch_deep(path)
    arr = path.split(".") 
    fetch_deep_with_index(self, arr, 0)
  end 
  def last_el(main_source)  
    each do |k, v|  
      if v.is_a?(Hash) == true
        v.last_el(main_source)
      else 
        self[k] = main_source.fetch_deep(v.to_s)     
      end  
    end
  end
  
  def reshape(form)
    form_work = {}
    form.each do |k, v|
      form_work.store(k, v)
    end
    form_work.last_el(self)
  end
end 
class Array
  def reshape(form)
    each do |e|
      new_hash = e.reshape(form)
      e.clear
      new_hash.each do |k, v| 
        e.store(k, v)
      end
    end
  end
end