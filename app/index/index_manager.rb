module IndexManager
  # Creates all the indexes specified in projects
  def create_all_indexes
    # Create the elasticsearch client for all models
    Elasticsearch::Model.client = Elasticsearch::Client.new log: true

    # Create all indexes (for each project)
    all_indexes = Project.all.map{|p| p.index_name}.uniq.compact
    all_indexes.each do |index|
      create_index(index, Elasticsearch::Model.client)
    end
  end

  # Create the index specified
  def create_index(index_name, client)
    # Check if it exists first
    if !client.indices.exists?(index: index_name)
      client.indices.create index: index_name
    end
  end
end
