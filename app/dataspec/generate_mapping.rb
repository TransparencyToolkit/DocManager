# Generates a mapping for an elasticsearch model
module GenerateMapping
  # Generate mapping for each field
  def map_all_fields(source)
    analyzer_hash = generate_analyzer_hash(source)
    
    # Generate mapping for each field
    source.source_fields.each do |field|
      gen_mapping_for_field(field, analyzer_hash)
    end
  end

  # Generate source mapping for analyzer
  def generate_analyzer_hash(source)
    analyzer_hash = {analyzer: source.mapping, term_vector: 'with_positions_offsets_payloads'}
    return analyzer_hash
  end

  # Infer the field type
  def infer_type(field)
    case field[1]["display_type"]
    when "Short Text", "Tiny Text", "Description", "Long Text", "Title"
      return String
    when "Date", "DateTime"
      return Date
    when "Category", "Link", "Picture"
      return String
    when "Number"
      return Integer
    end
  end

  # Generate a mapping for a specific field
  def gen_mapping_for_field(field, analyzer_hash)
    if field[0][0] != "_" # Ignore DB fields
      field_name = field[0].to_sym
      type = infer_type(field)
      return attribute field_name, type, mapping: analyzer_hash
    end
  end
end
