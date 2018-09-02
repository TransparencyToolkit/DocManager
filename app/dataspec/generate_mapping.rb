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
    analyzer_hash = {analyzer: source.mapping, term_vector: 'with_positions_offsets_payloads', store: true}
    return analyzer_hash
  end

  # Infer the field type
  def infer_type(field, analyzer_hash)
    case field[1]["display_type"]
    when "Short Text", "Tiny Text", "Description", "Long Text", "Title"
      return analyzer_hash.merge({type: "text"})
    when "Date", "DateTime"
      return {type: "date"}
    when "Category", "Link", "Picture", "None"
      return analyzer_hash.merge({type: "text", fields: {
                                    keyword: {
                                      type: "keyword",
                                      ignore_above: 256
                                    }}})
    when "Number"
      return {type: "long"}
    else
      return analyzer_hash
    end
  end

  # Generate a mapping for a specific field
  def gen_mapping_for_field(field, analyzer_hash)
    if field[0][0] != "_" # Ignore DB fields
      field_name = field[0].to_sym
      analyzer_hash = infer_type(field, analyzer_hash)

      # For doc_versions, it should take an object
      analyzer_hash = {properties: {}, type: "nested"} if field_name == :doc_versions
      
      # Set the mapping for the field
      mapping do
        indexes field_name, analyzer_hash 
      end
    end
  end
end
