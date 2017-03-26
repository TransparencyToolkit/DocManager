module IndexManager
  def self.create_index(index_name)
    client = Doc.gateway.client # UPDATE TO WORK WITH DYNAMIC DOC TYPES

    # Delete index if it already exists
    client.indices.delete index: index_name rescue nil

#    settings = ENAnalyzer.analyzerSettings
 #   mappings = doc_class.mappings.to_hash

    # Create index with appropriate settings and mappings
    client.indices.create index: index_name,
                          body: {} 
  end
end
