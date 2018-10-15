module ManageAnnotatorRecipeUpdates
  # Get a list of fields that have changed in an object
  def check_changed_fields(original, updated)
    changed_fields = Array.new

    # Go through all fields
    updated.each do |key, value|
      
      # Check if anything in a hash has been changed
      if original[key].class == Hash
        original[key].each do |k, v|
          changed_fields.push(key) if updated[key][k].to_s != v.to_s
        end
        
      else # Check if all other fields have been changed
        changed_fields.push(key) if original[key] != value
      end
    end

    return changed_fields.uniq
  end
end
