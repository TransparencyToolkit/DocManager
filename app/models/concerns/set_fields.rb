module SetFields
  extend ActiveSupport::Concern
  
  # Load each individual field into instance variable
  def load_fields(field_hash)
    field_hash.each do |key, value|
      self[key.to_sym] = value
    end
  end
end
