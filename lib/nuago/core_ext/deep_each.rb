module DeepEachForHashesAndArrays

  def _deep_fetch_build_key(path)
    if self.is_a?(::Array)
      raise ArgumentError, "#{key_or_path} is invalid index number" unless path[0].match(/\d/)
      path[0].to_i
    else
      path[0].to_sym
    end
  end

  def deep_each(base_key: nil, &blk)
    follow = -> (key, v) do
      if v.is_a?(::Hash) || v.is_a?(::Array)
        v.deep_each(base_key: key, &blk)
      else
        blk.call(key, v)
      end
    end

    if self.is_a?(::Array)
      self.each_with_index do |v, ki|
        key = base_key ? "#{base_key}.#{ki}" : "#{ki}"
        follow.call(key, v)
      end
    elsif self.is_a?(::Hash)
      self.each do |k, v|
        key = base_key ? "#{base_key}.#{k}" : "#{k}"
        follow.call(key, v)
      end
    end
  end
  
  def deep_fetch(key_or_path)
    path = key_or_path.is_a?(Array) ? key_or_path : key_or_path.split('.')
    return self if path.empty?
    
    
    curr_key = _deep_fetch_build_key(path)
    value = self[curr_key]
    
    if value.is_a?(Array) || value.is_a?(Hash)
      return value.deep_fetch(path[1..])
    elsif path.size > 1
      raise ArgumentError, "path is longer than available data ..."
    else
      return value
    end
  end

  def deep_assign(key_or_path, value)
    path = key_or_path.is_a?(Array) ? key_or_path : key_or_path.split('.')
    raise ArgumentError, 'path must be complete for assignment' if path.empty?
    
    curr_key = _deep_fetch_build_key(path)
    
    if path.size == 1
      # assign
      self[curr_key] = value
    else
      self[curr_key].deep_assign(path[1..], value)
    end

    self
  end
end
class Array
  include DeepEachForHashesAndArrays
end
class Hash
  include DeepEachForHashesAndArrays
end
# class Array
#   def deep_each(base_key: nil, &blk)
#     each_with_index do |v, ki|
      
#       key = base_key ? "#{base_key}.#{ki}" : "#{ki}"
      
#       if v.is_a?(Hash) || v.is_a?(Array)
#         v.deep_each(base_key: key, &blk)
#       else
#         blk.call(key, v)
#       end
#     end    
#   end

#   def deep_fetch(key_or_path)
#     path = key_or_path.is_a?(Array) ? key_or_path : key_or_path.split('.')
#     return self if path.empty?
#     raise ArgumentError, "#{key_or_path} is invalid index number" unless path[0].match(/\d/)
    
#     curr_key = path[0].to_i
#     value = self[curr_key]
    
#     if value.is_a?(Array) || value.is_a?(Hash)
#       return value.deep_fetch(path[1..])
    
#     elsif path.size > 1
#       raise ArgumentError, "path too long, value is #{value}"
    
#     else
#       return value
#     end
#   end

#   def deep_assign(key_or_path, value)
#     path = key_or_path.is_a?(Array) ? key_or_path : key_or_path.split('.')

#     raise ArgumentError, 'path must be complete for assignment' if path.empty?
    
#     curr_key = path[0].to_i
    
#     if path.size == 1
#       # assign
#       self[curr_key] = value
#     else
#       self[curr_key].deep_assign(path[1..], value)
#     end

#     self
#   end
# end

# class Hash
#   def deep_each(base_key: nil, &blk)
#     each do |k, v|
      
#       key = base_key ? "#{base_key}.#{k}" : "#{k}"
      
#       if v.is_a?(Hash) || v.is_a?(Array)
#         v.deep_each(base_key: key, &blk)
#       else
#         blk.call(key, v)
#       end
#     end
#   end

#   def deep_fetch(key_or_path)
#     path = key_or_path.is_a?(Array) ? key_or_path : key_or_path.split('.')

#     return self if path.empty?
    
#     curr_key = path[0].to_sym
#     value = self[curr_key]
    
#     if value.is_a?(Array) || value.is_a?(Hash)
#       return value.deep_fetch(path[1..])
#     elsif path.size > 1
#       raise ArgumentError, "path too long, value is #{value}"
#     else
#       return value
#     end
#   end

#   def deep_assign(key_or_path, value)
#     path = key_or_path.is_a?(Array) ? key_or_path : key_or_path.split('.')

#     raise ArgumentError, 'path must be complete for assignment' if path.empty?
    
#     curr_key = path[0].to_sym
    
#     if path.size == 1
#       # assign
#       self[curr_key] = value
#     else
#       self[curr_key].deep_assign(path[1..], value)
#     end

#     self
#   end
# end
