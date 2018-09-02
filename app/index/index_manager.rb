load 'app/analyzers/en_analyzer.rb'
load 'app/dataspec/retrieve_dataspec.rb'
load 'app/dataspec/generate_doc_model.rb'

module IndexManager
  include ENAnalyzer
  include GenerateDocModel
  include RetrieveDataspec
  # Creates all the indexes specified in projects
  def create_all_indexes
    # Create the elasticsearch client for all models
    Elasticsearch::Model.client = Elasticsearch::Client.new log: true

    # Create all indexes (for each project)
    Project.all.each do |project|
      create_index(project.index_name, project, Elasticsearch::Model.client)
    end
  end

  # Get a mappings hash for all document types in index
  def get_mappings_hash(index_name, datasources)
    mappings = Hash.new
    datasources.each do |source|
      model = get_model(index_name, source.class_name)
      mappings = mappings.merge(model.mappings.to_hash)
    end
    return mappings
  end

  # Create the index specified
  def create_index(index_name, project, client)
    # Check if it exists first
    if !client.indices.exists?(index: index_name)
      client.indices.create index: index_name,
                            body: {
                              settings: ENAnalyzer.analyzerSettings.to_hash,
                              mappings: get_mappings_hash(index_name, project.datasources)
                            }
    end
  end

  # Clear all for index
  def clear_all(index)
    Project.delete_all
    Elasticsearch::Model.client = Elasticsearch::Client.new log: true
    Elasticsearch::Model.client.indices.delete index: index rescue nil
  end
end
