# Create a class for the document model
module GenerateDocModel
  # Generate the document class
  def self.gen_doc_class(data_source)
    classname = gen_classname(data_source)

    # Don't redefine a class if it exists
    if (const_defined?(classname))
      return const_get(classname)
      
    else # Generate a class for the model
      new_model = Class.new(Object) do
        # Set name for class
        @classname = classname
        def self.model_name
          ActiveModel::Name.new(self, nil, @classname)
        end

        # Includes
        require 'elasticsearch/model'
        require 'elasticsearch/persistence/model'
        include Elasticsearch::Persistence::Model
        include Elasticsearch::Model

        # Load analyzer (update to load one specified in project)
        include ENAnalyzer
        settings = ENAnalyzer::analyzerSettings

        # Associate it with the correct project index
        index_name data_source.project.index_name

        # Generate the mapping
        extend GenerateMapping
        map_all_fields(data_source)
      end

      # Set constant and return class
      const_set(classname, new_model)
      return new_model
    end
  end

  # Generate the name for the datasource
  def self.gen_classname(data_source)
    source_class = data_source.class_name
    project_index_name = data_source.project.index_name.camelize
    return project_index_name+source_class
  end
end
