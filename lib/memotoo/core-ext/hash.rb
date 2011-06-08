# found here: http://coryodaniel.com/index.php/2009/12/30/ruby-getting-deeply-nested-values-from-a-hash-in-one-line-of-code/

# use with: @key_i_need = @event.seek :coordinator, :api_license, :key
# instead of:  @key_i_need = @event[:coordinator][:api_license][:key]

class Hash # :nodoc: all
  
  def seek(_keys_=[])
    last_level    = self
    sought_value  = nil
 
    _keys_.each_with_index do |_key_, _idx_|
      if last_level.is_a?(Hash) && last_level.has_key?(_key_)
        if _idx_ + 1 == _keys_.length
          sought_value = last_level[_key_]
        else                   
          last_level = last_level[_key_]
        end
      else 
        break
      end
    end
 
    sought_value
  end 
  
      # Returns a new Hash with +self+ and +other_hash+ merged recursively.
      # Modifies the receiver in place.
      # => already in savon gem 
      # =>  in case a time come and it will be away - just uncomment it
      def deep_merge_me!(other_hash)
        other_hash.each_pair do |k,v|
          tv = self[k]
          self[k] = tv.is_a?(Hash) && v.is_a?(Hash) ? tv.deep_merge_me!(v) : v
        end
        self
      end unless defined? deep_merge!
  
  
  
end
