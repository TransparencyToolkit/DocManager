module RetrieveDataspec
  include GenerateDocModel
  # Gets the model for the data type
  def get_model(index, doc_type)
    project = Project.where(index_name: index).first
    datasource = project.datasources.where(class_name: doc_type).first
    classname = GenerateDocModel.gen_classname(datasource)
    return Kernel.const_get("GenerateDocModel::#{classname}")
  end
end
